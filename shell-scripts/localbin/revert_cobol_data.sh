#!/usr/bin/env bash
# revert_cobol_data.sh
# Reverts the local /data LVM snapshot and restarts COBOL programs.
# Can run standalone (manages surveillance feed itself) or be called
# by revert_regression.sh with --skip-surveillance.
#
# Usage: revert_cobol_data.sh [--skip-surveillance-feed]

set -euo pipefail

SCRIPT_START=$(date +%s)
HOSTNAME_SHORT="$(hostname -s 2>/dev/null || hostname)"
SKIP_SURVEILLANCE=0

for arg in "$@"; do
    case "$arg" in
        --skip-surveillance-feed) SKIP_SURVEILLANCE=1 ;;
        *)
            echo "Usage: $0 [--skip-surveillance-feed]" >&2
            exit 1
            ;;
    esac
done

case "$HOSTNAME_SHORT" in
    prod10|prod60)
        echo "Error: revert_cobol_data.sh is not allowed on host $HOSTNAME_SHORT" >&2
        exit 1
        ;;
esac

SURVEILLANCE_SCRIPT="/usr/local/bin/surveillance_feed.sh"
STOP_PROGRAMS_SCRIPT="/usr/local/bin/stop_all_startup_programs.sh"
MANAGE_SNAPSHOT_SCRIPT="/usr/local/bin/manage_snapshot.sh"
SNAPSHOT_SIZE="50G"
PRIOR_FEED_STATE="disable"
FEED_DISABLE_ATTEMPTED=0

log() {
    echo "$(date '+%F %T') | ${HOSTNAME_SHORT} | $*"
}

elapsed() {
    local end
    end=$(date +%s)
    echo $(( end - SCRIPT_START ))
}

check_startup_storage() {
    local min_free_kb=1048576
    local min_free_inodes=1000
    local -a critical_paths=(/ /data /tmp /var /var/tmp /dev/shm)
    local path free_kb free_inodes

    log "Storage preflight before startup..."

    if command -v lvs >/dev/null 2>&1; then
        log "Snapshot utilization (if present):"
        lvs --noheadings -o lv_name,data_percent 2>/dev/null \
            | awk '/_snapshot/ {print $1, $2}' || true
    fi

    for path in "${critical_paths[@]}"; do
        [[ -d "$path" ]] || continue
        free_kb="$(timeout 10 df -Pk "$path" | awk 'NR==2 {print $4}')"
        free_inodes="$(timeout 10 df -Pi "$path" | awk 'NR==2 {print $4}')"

        if [[ -z "$free_kb" || -z "$free_inodes" ]]; then
            log "ERROR: Unable to read free space/inodes for $path"
            exit 1
        fi
        if (( free_kb < min_free_kb )); then
            log "ERROR: Low free space on $path (${free_kb} KB free)."
            exit 1
        fi
        if (( free_inodes < min_free_inodes )); then
            log "ERROR: Low free inodes on $path (${free_inodes} free)."
            exit 1
        fi
    done
}

# ------------------------------------------------------------------
# 1. Capture surveillance feed status, then disable (if managing it)
# ------------------------------------------------------------------
if [[ "$SKIP_SURVEILLANCE" -eq 0 ]]; then
    log "Checking surveillance feed status..."
    STATUS_OUTPUT=$("$SURVEILLANCE_SCRIPT" status 2>&1 || true)
    [[ -n "$STATUS_OUTPUT" ]] && echo "$STATUS_OUTPUT"

    if grep -q "Status: ENABLED" <<< "$STATUS_OUTPUT"; then
        PRIOR_FEED_STATE="enable"
    elif grep -q "Status: DISABLED" <<< "$STATUS_OUTPUT"; then
        PRIOR_FEED_STATE="disable"
    else
        log "WARNING: Could not determine surveillance feed status. Defaulting to disabled."
        PRIOR_FEED_STATE="disable"
    fi

    log "Surveillance feed prior state: ${PRIOR_FEED_STATE}"
    if [[ "$PRIOR_FEED_STATE" == "enable" ]]; then
        log "Disabling surveillance feed..."
        if "$SURVEILLANCE_SCRIPT" disable; then
            FEED_DISABLE_ATTEMPTED=1
            sleep 5
        else
            log "WARNING: Failed to disable surveillance feed; continuing."
        fi
    else
        log "Feed already disabled; no action required."
    fi
else
    log "Surveillance feed management skipped (--skip-surveillance)."
fi

# ------------------------------------------------------------------
# 2. Stop all startup programs
# ------------------------------------------------------------------
log "Stopping all startup programs..."
"$STOP_PROGRAMS_SCRIPT"
sleep 10

# ------------------------------------------------------------------
# 3. Revert /data snapshot
# ------------------------------------------------------------------
log "Reverting /data snapshot..."
"$MANAGE_SNAPSHOT_SCRIPT" revert -m /data
log "Snapshot revert complete."

# ------------------------------------------------------------------
# 4. Create new snapshot
# ------------------------------------------------------------------
log "Creating new snapshot (${SNAPSHOT_SIZE})..."
"$MANAGE_SNAPSHOT_SCRIPT" create -m /data -s "$SNAPSHOT_SIZE"
log "Snapshot creation complete."

# ------------------------------------------------------------------
# 5. Storage preflight
# ------------------------------------------------------------------
check_startup_storage

# ------------------------------------------------------------------
# 5b. Wait for ports to clear before startup
# ------------------------------------------------------------------
wait_for_ports_clear() {
    local -a ports=(10300 10200 10080 10700 10800 10900)
    local max_wait=120
    local interval=5
    local elapsed=0
    local in_use port

    log "Checking that required ports are free before startup..."

    while (( elapsed < max_wait )); do
        in_use=()
        for port in "${ports[@]}"; do
            # Match exact :PORT in local or peer address columns across all socket states.
            # Use awk (exits 0 even with no matches) to avoid pipefail exit on grep's non-zero.
            # timeout guards against ss hanging; || echo 0 handles timeout/error gracefully.
            local hits
            hits="$(timeout 10 /usr/sbin/ss -anp 2>/dev/null \
                | awk -v p=":${port}" '$4==p || $5==p || $6==p' \
                | wc -l || echo 0)"
            if [[ "$hits" -gt 0 ]]; then
                in_use+=("${port}(${hits})")
            fi
        done

        if [[ ${#in_use[@]} -eq 0 ]]; then
            log "All required ports are free. Proceeding with startup."
            return 0
        fi

        log "Ports still in use (${elapsed}s elapsed): ${in_use[*]} — waiting ${interval}s..."
        sleep "$interval"
        (( elapsed += interval ))
    done

    log "ERROR: Ports still in use after ${max_wait}s: ${in_use[*]}" >&2
    exit 1
}

wait_for_ports_clear

# ------------------------------------------------------------------
# 6. Start COBOL programs
# ------------------------------------------------------------------
log "Launching startup..."
nohup /usr/local/bin/startup.sh >/tmp/startup.sh.log 2>&1 &
log "Startup launched (PID: $!, log: /tmp/startup.sh.log)."

# ------------------------------------------------------------------
# 7. Restore surveillance feed (if managing it)
# ------------------------------------------------------------------
if [[ "$SKIP_SURVEILLANCE" -eq 0 ]]; then
    if [[ "$PRIOR_FEED_STATE" == "enable" && "$FEED_DISABLE_ATTEMPTED" -eq 1 ]]; then
        log "Restoring surveillance feed to: ${PRIOR_FEED_STATE}..."
        if ! "$SURVEILLANCE_SCRIPT" "${PRIOR_FEED_STATE}"; then
            log "WARNING: Failed to restore surveillance feed."
            exit 1
        fi
    else
        log "Skipping surveillance feed restore (was not disabled by this script)."
    fi
fi

# ------------------------------------------------------------------
# Runtime report
# ------------------------------------------------------------------
log "revert_cobol_data.sh complete. Runtime: $(elapsed)s"
