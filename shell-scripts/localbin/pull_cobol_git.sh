#!/usr/bin/env bash
set -euo pipefail

HOSTNAME_SHORT="$(hostname -s 2>/dev/null || hostname)"

case "$HOSTNAME_SHORT" in
	prod10|prod60)
		echo "Host $HOSTNAME_SHORT is excluded. Exiting."
		exit 0
		;;
esac

REPO_URL="${REPO_URL:-git@github.com:PharmacyDataManagement/COBOL_REPO.git}"
TAG_FILE="${TAG_FILE:-/usr/lnk/lst/git_commit.txt}"
STATE_FILE="${STATE_FILE:-/tmp/.pull_cobol_git_commit.sha256}"
S3_BUCKET="${S3_BUCKET:-s3://pdmi-qa-live-regression}"
S3_CANDIDATE_PREFIX="${S3_CANDIDATE_PREFIX:-candidate}"
S3_CURRENT_PREFIX="${S3_CURRENT_PREFIX:-current}"
AWS_S3_CP_OPTS="${AWS_S3_CP_OPTS:---only-show-errors}"
FORCE_RUN="${FORCE_RUN:-0}"

REMOTE_HOST="${REMOTE_HOST:-prod10-reg-live-cur}"
REMOTE_USER="${REMOTE_USER:-root}"
REMOTE_TAG_FILE="${REMOTE_TAG_FILE:-/usr/lnk/lst/git_commit.txt}"
SSH_OPTS="-o StrictHostKeyChecking=no -o BatchMode=yes -A"
SCP_OPTS="-o StrictHostKeyChecking=no -o BatchMode=yes"

LOCK_FILE="/tmp/.pull_cobol_git.pid"

# --- PID-file locking: prevent concurrent runs ---
if [[ -f "$LOCK_FILE" ]]; then
	existing_pid="$(<"$LOCK_FILE")"
	if [[ -n "$existing_pid" ]] && kill -0 "$existing_pid" 2>/dev/null; then
		echo "Already running (PID $existing_pid). Exiting."
		exit 0
	else
		echo "Removing stale lock file (PID $existing_pid no longer alive)."
		rm -f "$LOCK_FILE"
	fi
fi
printf '%s' "$$" > "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

usage() {
	echo "Usage: $0 [-f] [-h] [destination_dir]"
	echo "  -f  Force execution even if $TAG_FILE has not changed"
	echo "  -h  Show this help"
	echo "Reads tag from $TAG_FILE and clones that tag from $REPO_URL"
	echo "Uploads CBL_BATCH/compu05.cbl and CBL_BATCH/C5sub*.cbl to $S3_BUCKET/<git_commit_first_token>/$S3_CANDIDATE_PREFIX"
}

upload_cbl_files() {
	local repo_dir="$1"
	local s3_base_dir="$2"
	local s3_prefix="$3"
	local suffix="$4"
	local cbl_batch_dir="$repo_dir/CBL_BATCH"
	local -a files

	if [[ ! -d "$cbl_batch_dir" ]]; then
		echo "Error: expected directory not found: $cbl_batch_dir" >&2
		return 1
	fi

	shopt -s nullglob nocaseglob
	files=("$cbl_batch_dir"/compu05.cbl "$cbl_batch_dir"/C5sub*.cbl)
	shopt -u nullglob nocaseglob

	if [[ ${#files[@]} -eq 0 ]]; then
		echo "Error: no matching files found in $cbl_batch_dir" >&2
		return 1
	fi

	for source_file in "${files[@]}"; do
		local base_name stem normalized_stem target_name target_s3

		base_name="$(basename "$source_file")"
		stem="${base_name%.*}"
		normalized_stem="${stem^^}"
		target_name="${normalized_stem}${suffix}"
		target_s3="$S3_BUCKET/$s3_base_dir/$s3_prefix/$target_name"

		echo "Uploading $base_name as $target_name to $target_s3"
		/usr/local/bin/aws s3 cp $AWS_S3_CP_OPTS "$source_file" "$target_s3"
	done
}

upload_candidate_files() {
	upload_cbl_files "$1" "$S3_BASE_DIR" "$S3_CANDIDATE_PREFIX" "_candidate.txt"
}

copy_pdf_file() {
	local source_file="/usr/rmcobol/rmcobol_syntaxsummary_v12.21.pdf"
	local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	local dest_file="$script_dir/rmcobol_syntaxsummary.pdf"
	local s3_dest="$S3_BUCKET/rmcobol_syntaxsummary.pdf"
	
	if [[ ! -f "$source_file" ]]; then
		echo "Warning: source file not found: $source_file" >&2
		return 1
	fi
	
	echo "Copying $source_file to $dest_file..."
	if cp "$source_file" "$dest_file"; then
		echo "Successfully copied to $dest_file"
		echo "Uploading to $s3_dest..."
		if /usr/local/bin/aws s3 cp $AWS_S3_CP_OPTS "$dest_file" "$s3_dest"; then
			echo "Successfully uploaded to S3"
		else
			echo "Error: failed to upload to S3" >&2
			return 1
		fi
	else
		echo "Error: failed to copy $source_file" >&2
		return 1
	fi
}

while getopts ':fh' opt; do
	case "$opt" in
		f) FORCE_RUN=1 ;;
		h) usage; exit 0 ;;
		*) usage; exit 1 ;;
	esac
done
shift $((OPTIND - 1))

if [[ $# -gt 1 ]]; then
	usage
	exit 1
fi

if [[ ! -f "$TAG_FILE" ]]; then
	echo "Error: tag file not found: $TAG_FILE" >&2
	exit 1
fi

CURRENT_TAG_FILE_HASH="$(sha256sum "$TAG_FILE" | awk '{print $1}')"
PREVIOUS_TAG_FILE_HASH=""

if [[ -f "$STATE_FILE" ]]; then
	PREVIOUS_TAG_FILE_HASH="$(<"$STATE_FILE")"
fi

if [[ "$FORCE_RUN" != "1" && "$CURRENT_TAG_FILE_HASH" == "$PREVIOUS_TAG_FILE_HASH" ]]; then
	echo "No change detected in $TAG_FILE; skipping clone."
	exit 0
fi

TAG="$(awk 'NF {print $1; exit}' "$TAG_FILE")"
if [[ -z "$TAG" ]]; then
	echo "Error: tag file is empty: $TAG_FILE" >&2
	exit 1
fi

S3_BASE_DIR="$TAG"

DEST_DIR="${1:-}"
if [[ -z "$DEST_DIR" ]]; then
	DEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/cobol_repo.XXXXXX")"
	echo "No destination provided. Using temporary directory: $DEST_DIR"
else
	mkdir -p "$DEST_DIR"
	if [[ -n "$(ls -A "$DEST_DIR")" ]]; then
		echo "Error: destination directory is not empty: $DEST_DIR" >&2
		exit 1
	fi
fi

# Reset the regression.
/usr/local/bin/revert_regression.sh


echo "Cloning tag '$TAG' from $REPO_URL..."
GIT_SSH_COMMAND="ssh $SSH_OPTS" git clone --depth 1 --branch "$TAG" --single-branch "$REPO_URL" "$DEST_DIR"

upload_candidate_files "$DEST_DIR"

# --- Current side: fetch remote git_commit.txt, clone that tag, upload current files ---

REMOTE_TAG_FILE_LOCAL="$(mktemp /tmp/.current_git_commit.XXXXXX)"
if ! scp -q $SCP_OPTS "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_TAG_FILE}" "$REMOTE_TAG_FILE_LOCAL" 2>/dev/null; then
	echo "Error: failed to fetch $REMOTE_TAG_FILE from $REMOTE_HOST" >&2
	rm -f "$REMOTE_TAG_FILE_LOCAL"
else
	CURRENT_TAG="$(awk 'NF {print $1; exit}' "$REMOTE_TAG_FILE_LOCAL")"
	rm -f "$REMOTE_TAG_FILE_LOCAL"

	if [[ -z "$CURRENT_TAG" ]]; then
		echo "Error: first token missing in remote $REMOTE_TAG_FILE" >&2
	else
		CURRENT_DEST_DIR="$(mktemp -d /tmp/cobol_repo_current.XXXXXX)"
		echo "Cloning current tag '$CURRENT_TAG' from $REPO_URL..."
		if GIT_SSH_COMMAND="ssh $SSH_OPTS" git clone --depth 1 --branch "$CURRENT_TAG" --single-branch "$REPO_URL" "$CURRENT_DEST_DIR"; then
			upload_cbl_files "$CURRENT_DEST_DIR" "$S3_BASE_DIR" "$S3_CURRENT_PREFIX" "_current.txt"
			echo "Done. Checked out current tag '$CURRENT_TAG' in: $CURRENT_DEST_DIR"
		else
			echo "Error: failed to clone current tag '$CURRENT_TAG'" >&2
		fi
		rm -rf "$CURRENT_DEST_DIR"
	fi
fi

mkdir -p "$(dirname "$STATE_FILE")"
printf '%s' "$CURRENT_TAG_FILE_HASH" > "$STATE_FILE"

copy_pdf_file || true

echo "Done. Checked out candidate tag '$TAG' in: $DEST_DIR"
