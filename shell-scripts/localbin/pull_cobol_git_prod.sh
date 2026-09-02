#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-git@github.com:PharmacyDataManagement/COBOL_REPO.git}"
TAG_FILE="${TAG_FILE:-/usr/lnk/lst/git_commit.txt}"
STATE_FILE="${STATE_FILE:-/tmp/.pull_cobol_git_prod_commit.sha256}"
S3_BUCKET="${S3_BUCKET:-s3://pdmi-cobol-code}"
AWS_S3_CP_OPTS="${AWS_S3_CP_OPTS:---only-show-errors --no-progress}"
FORCE_RUN="${FORCE_RUN:-0}"

SSH_OPTS="-o StrictHostKeyChecking=no -o BatchMode=yes -A"

LOCK_FILE="/tmp/.pull_cobol_git_prod.pid"

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
	echo "Uploads CBL_BATCH/compu05.cbl and CBL_BATCH/C5sub*.cbl to $S3_BUCKET/<git_commit_first_token>/"
	echo "Uploads /usr/lnk/shell/env_var to $S3_BUCKET/<git_commit_first_token>/release/env_var"
}

upload_cbl_files() {
	local repo_dir="$1"
	local s3_base_dir="$2"
	local tag="$3"
	local -a dirs=(CBL_BATCH CPY NEWCPY)
	local parallel_jobs=2

	for dir in "${dirs[@]}"; do
		local dir_path="$repo_dir/$dir"
		if [[ ! -d "$dir_path" ]]; then
			echo "Warning: directory not found: $dir_path" >&2
			continue
		fi

		# Export variables for xargs subshell
		export S3_BUCKET dir_path dir tag s3_base_dir AWS_S3_CP_OPTS

		# Find all files and upload them in parallel
		find "$dir_path" -type f | xargs -P "$parallel_jobs" -I {} bash -c '
			source_file="$1"
			relative_path="${source_file#$2/}"
			target_name="${relative_path}_$4.txt"
			target_s3="$5/$6/$3/${target_name}"

			echo "Uploading $relative_path as $target_name to $target_s3"
			/usr/local/bin/aws s3 cp $7 "$source_file" "$target_s3"
		' _ {} "$dir_path" "$dir" "$tag" "$S3_BUCKET" "$s3_base_dir" "$AWS_S3_CP_OPTS"
	done
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

copy_lrm_pdf() {
	local source_file="/usr/rmcobol/rmc-lrm.pdf"
	local s3_dest="$S3_BUCKET/rmc-lrm.pdf"

	if [[ ! -f "$source_file" ]]; then
		echo "Warning: source file not found: $source_file" >&2
		return 1
	fi

	echo "Uploading $source_file to $s3_dest..."
	if /usr/local/bin/aws s3 cp $AWS_S3_CP_OPTS "$source_file" "$s3_dest"; then
		echo "Successfully uploaded to S3"
	else
		echo "Error: failed to upload to S3" >&2
		return 1
	fi
}

copy_env_var_to_release() {
	local source_file="/usr/lnk/shell/env_var"
	local target_name="env_var_${S3_BASE_DIR}.txt"
	local s3_dest="$S3_BUCKET/$S3_BASE_DIR/$target_name"

	if [[ ! -f "$source_file" ]]; then
		echo "Warning: source file not found: $source_file" >&2
		return 1
	fi

	echo "Uploading $source_file as $target_name to $s3_dest..."
	if /usr/local/bin/aws s3 cp $AWS_S3_CP_OPTS "$source_file" "$s3_dest"; then
		echo "Successfully uploaded env_var to release folder"
	else
		echo "Error: failed to upload env_var to S3 release folder" >&2
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

TAG_FILE_HASH="$(sha256sum "$TAG_FILE" | awk '{print $1}')"
PREVIOUS_TAG_FILE_HASH=""

if [[ -f "$STATE_FILE" ]]; then
	PREVIOUS_TAG_FILE_HASH="$(<"$STATE_FILE")"
fi

if [[ "$FORCE_RUN" != "1" && "$TAG_FILE_HASH" == "$PREVIOUS_TAG_FILE_HASH" ]]; then
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


echo "Cloning tag '$TAG' from $REPO_URL..."
GIT_SSH_COMMAND="ssh $SSH_OPTS" git clone --depth 1 --branch "$TAG" --single-branch "$REPO_URL" "$DEST_DIR"

upload_cbl_files "$DEST_DIR" "$S3_BASE_DIR" "$TAG"
copy_env_var_to_release || true

mkdir -p "$(dirname "$STATE_FILE")"
printf '%s' "$TAG_FILE_HASH" > "$STATE_FILE"

copy_pdf_file || true
copy_lrm_pdf || true

echo "Done. Checked out tag '$TAG' in: $DEST_DIR"
