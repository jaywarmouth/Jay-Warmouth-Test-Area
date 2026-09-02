#!/usr/bin/env bash
set -euo pipefail

HOSTNAME_SHORT="$(hostname -s 2>/dev/null || hostname)"

case "$HOSTNAME_SHORT" in
  prod10|prod60)
    echo "Host $HOSTNAME_SHORT is excluded. Exiting."
    exit 0
    ;;
esac

TARGET_FS="/data"

run_stop_commands() {
  echo "==> Running configured stop commands..."

  /usr/local/bin/kill_t02.sh 10 
  /usr/local/bin/kill_t02.sh 16 
  /usr/local/bin/kill_t02.sh 40 
  /usr/local/bin/kill_t02.sh 60 
  /usr/local/bin/kill_t02.sh 70 
  /usr/local/bin/kill_t02.sh 90 
  /usr/local/bin/kill_t02.sh dir 

  # Safely kill processes by exact name, excluding this script and its parent shell
  local -a processes=(elgrt02_auto.sh clmrt01_auto.sh runcobol queue2post.sh tcplinedrv queue2post tcpfileclaim)
  local pid proc

  for proc in "${processes[@]}"; do
    while IFS= read -r pid; do
      if [[ -n "$pid" && "$pid" != "0" && "$pid" != "1" && "$pid" != "$$" && "$pid" != "${PPID}" ]]; then
        echo "==> Sending SIGTERM to $proc (PID: $pid)" >&2
        kill -TERM "$pid" 2>/dev/null || true
      fi
    done < <(pgrep -x "$proc" 2>/dev/null || true)
  done

  sleep 1

  # Safely kill processes by exact name, excluding this script and its parent shell
  local -a processes=(elgrt02_auto.sh clmrt01_auto.sh runcobol queue2post.sh tcplinedrv queue2post tcpfileclaim)
  local pid proc

  for proc in "${processes[@]}"; do
    while IFS= read -r pid; do
      if [[ -n "$pid" && "$pid" != "0" && "$pid" != "1" && "$pid" != "$$" && "$pid" != "${PPID}" ]]; then
        echo "==> Sending SIGKILL to $proc (PID: $pid)" >&2
        kill -9 "$pid" 2>/dev/null || true
      fi
    done < <(pgrep -x "$proc" 2>/dev/null || true)
  done

  sleep 1

  # Force kill any remaining queue2post processes (excluding this script)
  while IFS= read -r pid; do
    if [[ -n "$pid" && "$pid" != "0" && "$pid" != "1" && "$pid" != "$$" && "$pid" != "${PPID}" ]]; then
      echo "==> Sending SIGKILL to queue2post (PID: $pid)" >&2
      kill -9 "$pid" 2>/dev/null || true
    fi
  done < <(pgrep -x "queue2post" 2>/dev/null || true)



  # Add your explicit program stop commands below.
  # Keep '|| true' on each line so one failure does not skip the remaining stops.
  # Example:
  # systemctl stop my-service-a || true
  # systemctl stop my-service-b || true

  :
}

kill_data_users() {
  local -a pids
  local pid

  echo "==> Looking for processes using ${TARGET_FS}..."

  if [[ ! -x /usr/sbin/fuser ]]; then
    echo "ERROR: /usr/sbin/fuser is required for ${TARGET_FS} process cleanup." >&2
    return 1
  fi

  # fuser output can include formatting noise; keep numeric PIDs only.
  mapfile -t pids < <(/usr/sbin/fuser -m "$TARGET_FS" 2>/dev/null | tr ' ' '\n' | grep -E '^[0-9]+$' | sort -u)

  if [[ ${#pids[@]} -eq 0 ]]; then
    echo "==> No processes are using ${TARGET_FS}."
    return 0
  fi

  # Build exclusion pattern: this script/shell + PID 0/1 + all sshd PIDs.
  local -a sshd_pids=()
  mapfile -t sshd_pids < <(pgrep -x sshd 2>/dev/null || true)
  local exclude_pattern="^(0|1|$$|${PPID}"
  for _pid in "${sshd_pids[@]:-}"; do
    [[ -n "$_pid" ]] && exclude_pattern+="|${_pid}"
  done
  exclude_pattern+=")$"

  mapfile -t pids < <(printf '%s\n' "${pids[@]}" | grep -Ev "$exclude_pattern" || true)

  if [[ ${#pids[@]} -eq 0 ]]; then
    echo "==> Only current script/shell were using ${TARGET_FS}; nothing to terminate."
    return 0
  fi

  echo "==> Sending SIGTERM to PIDs: ${pids[*]}"
  for pid in "${pids[@]}"; do
    kill -TERM "$pid" 2>/dev/null || true
    
  done

  sleep 2

  local -a still_running=()
  for pid in "${pids[@]}"; do
    if kill -0 "$pid" 2>/dev/null; then
      still_running+=("$pid")
    fi
  done

  if [[ ${#still_running[@]} -gt 0 ]]; then
    echo "==> Sending SIGKILL to stubborn PIDs: ${still_running[*]}"
    for pid in "${still_running[@]}"; do
      kill -KILL "$pid" 2>/dev/null || true
    done
  fi

  echo "==> ${TARGET_FS} process cleanup complete."
}

echo "==> stop_all_startup_programs.sh starting on host: ${HOSTNAME_SHORT}"
run_stop_commands
#kill_data_users

echo "==> stop_all_startup_programs.sh complete."
