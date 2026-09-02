#!/bin/bash
################################################################################
# manage_channel_daemon_go.sh - Start / Stop / Status for Go HTTP channel daemon
#
# Usage:
#   manage_channel_daemon_go.sh start   - Start the daemon in background
#   manage_channel_daemon_go.sh stop    - Graceful shutdown via API
#   manage_channel_daemon_go.sh restart - Stop then start
#   manage_channel_daemon_go.sh status  - Show running state and stats
#   manage_channel_daemon_go.sh kill    - Force kill if graceful stop fails
################################################################################

DAEMON_BIN="/usr/local/load_eligibility_venv/bin/channel_daemon_go"
PID_FILE="/usr/lnk/tmp/channel_daemon.pid"
LOG_FILE="/usr/lnk/tmp/channel_daemon.log"
API_URL="http://127.0.0.1:5100"

# ── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

is_running() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE" 2>/dev/null)
        if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

api_reachable() {
    curl -s -o /dev/null -w "%{http_code}" "$API_URL/health" 2>/dev/null | grep -q "200\|503"
}

do_start() {
    if is_running; then
        PID=$(cat "$PID_FILE")
        echo -e "${YELLOW}Daemon already running (PID $PID)${NC}"
        return 0
    fi

    echo -n "Starting Go channel daemon... "

    # Verify daemon binary exists
    if [ ! -f "$DAEMON_BIN" ]; then
        echo -e "${RED}FAILED${NC}"
        echo "  Binary not found: $DAEMON_BIN"
        echo "  Build with: cd go_service_cobol_mysql/services/go && ./build.sh  (or build.bat on Windows)"
        return 1
    fi

    # Make executable
    chmod +x "$DAEMON_BIN"

    # Start daemon
    nohup "$DAEMON_BIN" >> "$LOG_FILE" 2>&1 &
    DAEMON_PID=$!

    # Wait for startup
    sleep 2

    # Verify it's running
    if kill -0 "$DAEMON_PID" 2>/dev/null; then
        echo -e "${GREEN}OK${NC} (PID $DAEMON_PID)"
        
        # Wait for API to be ready
        for i in {1..10}; do
            if api_reachable; then
                echo -e "${GREEN}API ready${NC} at $API_URL"
                return 0
            fi
            sleep 1
        done
        
        echo -e "${YELLOW}API not responding${NC}"
        return 1
    else
        echo -e "${RED}FAILED${NC}"
        echo "  Check log: tail -f $LOG_FILE"
        return 1
    fi
}

do_stop() {
    if ! is_running; then
        echo -e "${YELLOW}Daemon not running${NC}"
        rm -f "$PID_FILE"
        return 0
    fi

    PID=$(cat "$PID_FILE")
    echo -n "Stopping Go channel daemon (PID $PID)... "

    # Try graceful shutdown via API
    if api_reachable; then
        shutdown_args=()
        [ -n "$CHANNEL_DAEMON_SHUTDOWN_TOKEN" ] && shutdown_args=(-H "X-Shutdown-Token:${CHANNEL_DAEMON_SHUTDOWN_TOKEN}")
        curl -s -X POST "${shutdown_args[@]}" "$API_URL/shutdown" > /dev/null 2>&1
        sleep 2
    fi

    # Check if stopped
    if ! kill -0 "$PID" 2>/dev/null; then
        echo -e "${GREEN}OK${NC}"
        rm -f "$PID_FILE"
        return 0
    fi

    # Send SIGTERM
    kill "$PID" 2>/dev/null
    for i in {1..5}; do
        if ! kill -0 "$PID" 2>/dev/null; then
            echo -e "${GREEN}OK${NC}"
            rm -f "$PID_FILE"
            return 0
        fi
        sleep 1
    done

    echo -e "${YELLOW}Still running${NC}"
    echo "  Use '$0 kill' to force stop"
    return 1
}

do_kill() {
    if ! is_running; then
        echo -e "${YELLOW}Daemon not running${NC}"
        rm -f "$PID_FILE"
        return 0
    fi

    PID=$(cat "$PID_FILE")
    echo -n "Force killing daemon (PID $PID)... "
    kill -9 "$PID" 2>/dev/null
    sleep 1

    if ! kill -0 "$PID" 2>/dev/null; then
        echo -e "${GREEN}OK${NC}"
        rm -f "$PID_FILE"
        return 0
    else
        echo -e "${RED}FAILED${NC}"
        return 1
    fi
}

do_status() {
    if is_running; then
        PID=$(cat "$PID_FILE")
        echo -e "${GREEN}Running${NC} (PID $PID)"
        
        # Get stats from API
        if api_reachable; then
            echo ""
            echo "API Status:"
            STATS=$(curl -s "$API_URL/stats" 2>/dev/null)
            if [ $? -eq 0 ]; then
                echo "$STATS" | python3 -m json.tool 2>/dev/null || echo "$STATS"
            fi
        else
            echo -e "${YELLOW}API not responding${NC}"
        fi
    else
        echo -e "${RED}Not running${NC}"
        rm -f "$PID_FILE"
    fi
}

do_restart() {
    do_stop
    sleep 1
    do_start
}

# ── Main ─────────────────────────────────────────────────────────────────────

case "${1:-}" in
    start)
        do_start
        ;;
    stop)
        do_stop
        ;;
    restart)
        do_restart
        ;;
    status)
        do_status
        ;;
    kill)
        do_kill
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|kill}"
        exit 1
        ;;
esac
