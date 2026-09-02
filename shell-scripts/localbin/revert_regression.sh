#!/bin/bash
# revert_regression.sh
# Coordinator: reverts both prod10-reg-live-can (local) and prod10-reg-live-cur (remote)
# simultaneously by running revert_cobol_data.sh on each server in parallel.
# Manages surveillance feed enable/disable around the full operation.
#
# Must run on prod10-reg-live-can.

set -euo pipefail

SCRIPT_START=$(date +%s)
HOSTNAME_SHORT="$(hostname -s 2>/dev/null || hostname)"

case "$HOSTNAME_SHORT" in
    prod10-reg-live-can)
        # Correct host, continue.
        ;;
    *)
        echo "Error: revert_regression.sh must run on prod10-reg-live-can. Current host: $HOSTNAME_SHORT" >&2
        exit 1
        ;;
esac

SURVEILLANCE_SCRIPT="/usr/local/bin/surveillance_feed.sh"
LOCAL_REVERT_SCRIPT="/usr/local/bin/revert_cobol_data.sh"
REMOTE_HOST="prod10-reg-live-cur"
REMOTE_REVERT_SCRIPT="/usr/local/bin/revert_cobol_data.sh"

PRIOR_FEED_STATE="disable"
FEED_DISABLE_ATTEMPTED=0
SKIP_RTC_CLEANUP=0

LOCAL_LOG="/tmp/revert_cobol_data_local.log"
REMOTE_LOG="/tmp/revert_cobol_data_remote.log"
LOCAL_EXIT_FILE="/tmp/revert_local_exit"
REMOTE_EXIT_FILE="/tmp/revert_remote_exit"

# --- Argument parsing ---
for arg in "$@"; do
    case "$arg" in
        --skip-rtc-cleanup) SKIP_RTC_CLEANUP=1 ;;
        *) echo "Unknown argument: $arg" >&2; exit 1 ;;
    esac
done

log() {
    echo "$(date '+%F %T') | revert_regression | $*"
}

elapsed() {
    local end
    end=$(date +%s)
    echo $(( end - SCRIPT_START ))
}

stream_logs() {
    # Interleave LOCAL_LOG and REMOTE_LOG in real time, prefixed with server name.
    local local_pos=0 remote_pos=0
    local line

    while true; do
        # Drain any new lines from local log
        while IFS= read -r line; do
            echo "$(date '+%F %T') | ${HOSTNAME_SHORT} | ${line}"
        done < <(tail -n "+$((local_pos + 1))" "$LOCAL_LOG" 2>/dev/null)
        local_pos=$(wc -l < "$LOCAL_LOG" 2>/dev/null || echo 0)

        # Drain any new lines from remote log
        while IFS= read -r line; do
            echo "$(date '+%F %T') | ${REMOTE_HOST} | ${line}"
        done < <(tail -n "+$((remote_pos + 1))" "$REMOTE_LOG" 2>/dev/null)
        remote_pos=$(wc -l < "$REMOTE_LOG" 2>/dev/null || echo 0)

        # Check if local process is dead but no exit file written
        if ! kill -0 "$LOCAL_PID" 2>/dev/null && [[ ! -f "$LOCAL_EXIT_FILE" ]]; then
            log "WARNING: Local process (PID $LOCAL_PID) exited unexpectedly without recording exit code."
            echo 1 >"$LOCAL_EXIT_FILE"
        fi

        # Check if remote process is dead but no exit file written
        if ! kill -0 "$REMOTE_PID" 2>/dev/null && [[ ! -f "$REMOTE_EXIT_FILE" ]]; then
            log "WARNING: Remote process (PID $REMOTE_PID) exited unexpectedly without recording exit code."
            echo 1 >"$REMOTE_EXIT_FILE"
        fi

        # Stop if both processes have finished
        if [[ -f "$LOCAL_EXIT_FILE" && -f "$REMOTE_EXIT_FILE" ]]; then
            # Final drain
            while IFS= read -r line; do
                echo "$(date '+%F %T') | ${HOSTNAME_SHORT} | ${line}"
            done < <(tail -n "+$((local_pos + 1))" "$LOCAL_LOG" 2>/dev/null)
            while IFS= read -r line; do
                echo "$(date '+%F %T') | ${REMOTE_HOST} | ${line}"
            done < <(tail -n "+$((remote_pos + 1))" "$REMOTE_LOG" 2>/dev/null)
            break
        fi

        sleep 0.5
    done
}

# ------------------------------------------------------------------
# 1. Disable surveillance feed
# ------------------------------------------------------------------
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
        log "Surveillance feed disabled successfully. Waiting 60 seconds for in-flight transactions to compmlete..."
        sleep 60  # Wait for feed to fully disable before proceeding
    else
        log "WARNING: Failed to disable surveillance feed; continuing."
    fi
else
    log "Feed already disabled; no action required."
fi

# ------------------------------------------------------------------
# 1b. Clean up /data/rxconnect/compu05_rxconnect on local server
# ------------------------------------------------------------------
if [[ "$SKIP_RTC_CLEANUP" -eq 0 ]]; then
    log "Cleaning /data/rxconnect/compu05_rxconnect on ${HOSTNAME_SHORT}..."
    if [[ -d /data/rxconnect/compu05_rxconnect ]]; then
        find /data/rxconnect/compu05_rxconnect/ -mindepth 1 -delete
        log "/data/rxconnect/compu05_rxconnect cleared."
    else
        log "/data/rxconnect/compu05_rxconnect does not exist; skipping."
    fi
else
    log "Skipping /data/rxconnect/compu05_rxconnect cleanup (--skip-rtc-cleanup specified)."
fi

# ------------------------------------------------------------------
# 2. Launch revert_cobol_data.sh on both servers simultaneously
# ------------------------------------------------------------------
log "Launching revert_cobol_data.sh on local (${HOSTNAME_SHORT}) and remote (${REMOTE_HOST}) in parallel..."

rm -f "$LOCAL_LOG" "$REMOTE_LOG" "$LOCAL_EXIT_FILE" "$REMOTE_EXIT_FILE"
touch "$LOCAL_LOG" "$REMOTE_LOG"

# Local: run in background, capture output, record exit code
(
    bash "$LOCAL_REVERT_SCRIPT" --skip-surveillance-feed >"$LOCAL_LOG" 2>&1
    echo $? >"$LOCAL_EXIT_FILE"
) &
LOCAL_PID=$!

# Remote: run over SSH in background, capture output, record exit code
(
    ssh -o StrictHostKeyChecking=no -o BatchMode=yes "$REMOTE_HOST" \
        "bash $REMOTE_REVERT_SCRIPT --skip-surveillance-feed" >"$REMOTE_LOG" 2>&1
    echo $? >"$REMOTE_EXIT_FILE"
) &
REMOTE_PID=$!

# ------------------------------------------------------------------
# 3. Stream interleaved output until both finish
# ------------------------------------------------------------------
stream_logs

# ------------------------------------------------------------------
# 4. Collect exit codes — fail-fast if either failed
# ------------------------------------------------------------------
LOCAL_RC=$(cat "$LOCAL_EXIT_FILE" 2>/dev/null || echo 1)
REMOTE_RC=$(cat "$REMOTE_EXIT_FILE" 2>/dev/null || echo 1)

FAILED=0
if [[ "$LOCAL_RC" -ne 0 ]]; then
    log "ERROR: revert_cobol_data.sh FAILED on ${HOSTNAME_SHORT} (exit ${LOCAL_RC})."
    FAILED=1
fi
if [[ "$REMOTE_RC" -ne 0 ]]; then
    log "ERROR: revert_cobol_data.sh FAILED on ${REMOTE_HOST} (exit ${REMOTE_RC})."
    FAILED=1
fi

if [[ "$FAILED" -eq 1 ]]; then
    log "One or more servers failed. Surveillance feed will NOT be restored. Manual intervention required."
    exit 1
fi

log "Both servers completed successfully."

# ------------------------------------------------------------------
# 5. Restore surveillance feed
# ------------------------------------------------------------------
if [[ "$PRIOR_FEED_STATE" == "enable" && "$FEED_DISABLE_ATTEMPTED" -eq 1 ]]; then
    log "Restoring surveillance feed to: ${PRIOR_FEED_STATE}..."
    if ! "$SURVEILLANCE_SCRIPT" "${PRIOR_FEED_STATE}"; then
        log "WARNING: Failed to restore surveillance feed."
        exit 1
    fi
else
    log "Skipping surveillance feed restore (was not disabled by this script)."
fi

# ------------------------------------------------------------------
# Runtime report
# ------------------------------------------------------------------
log "=== Runtime Summary ==="
log "  Local  (${HOSTNAME_SHORT}): exit ${LOCAL_RC}"
log "  Remote (${REMOTE_HOST}):    exit ${REMOTE_RC}"
log "  Total runtime: $(elapsed)s"
log "revert_regression.sh complete."


log "revert_regression.sh complete."

