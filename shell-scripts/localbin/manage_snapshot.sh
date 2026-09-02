#!/usr/bin/env bash
set -euo pipefail

# Manage LVM snapshots for a mounted filesystem.
# Actions:
#   create - create snapshot of the LV backing the mount point
#   revert - merge snapshot back into origin LV
#   drop   - remove snapshot and keep current origin changes
#   status - display snapshot/origin status
#
# Examples:
#   ./manage_snapshot.sh create -m /data -s 20G
#   ./manage_snapshot.sh create -m /data -s AUTO -r 1
#   ./manage_snapshot.sh status -m /data
#   ./manage_snapshot.sh revert -m /data
#   ./manage_snapshot.sh drop -m /data

ACTION="${1:-}"
if [[ -z "$ACTION" ]]; then
  ACTION="help"
fi
if [[ $# -gt 0 ]]; then
  shift
fi

MOUNT_POINT=""
SNAP_NAME=""
SNAP_SIZE="AUTO"
VG_RESERVE_EXTENTS=1

usage() {
  cat <<'EOF'
Usage:
  manage_snapshot.sh <action> -m <mount_point> [options]

Actions:
  create    Create a snapshot for the mount point
  revert    Revert origin LV by merging snapshot
  drop      Remove snapshot and keep current origin LV data
  status    Show snapshot/origin status
  help      Show this help

Required:
  -m PATH   Mount point to manage (example: /data)

Options:
  -n NAME   Snapshot LV name (default: <origin_lv>_snapshot)
  -s SIZE   Snapshot size for create (e.g. 20G or AUTO, default: AUTO)
  -r NUM    Reserved free extents to keep in VG when -s AUTO (default: 1)
  -h        Show this help

Notes:
  - Revert uses lvconvert --merge on the snapshot.
  - Drop removes the snapshot LV without merging; current origin data is kept as-is.
  - If the origin mount is in use, unmount/deactivate may fail and require maintenance window.
EOF
}

while getopts ":m:n:s:r:h" opt; do
  case "$opt" in
    m) MOUNT_POINT="$OPTARG" ;;
    n) SNAP_NAME="$OPTARG" ;;
    s) SNAP_SIZE="$OPTARG" ;;
    r) VG_RESERVE_EXTENTS="$OPTARG" ;;
    h)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Error: required command not found: $1" >&2
    exit 1
  }
}

wait_for_device() {
  local device_path="$1"
  local timeout="${2:-30}"
  local elapsed=0

  echo "Waiting for device to become available: $device_path (timeout: ${timeout}s)"

  # Give udev a short head-start; the polling loop below handles the real wait.
  if command -v udevadm >/dev/null 2>&1; then
    udevadm settle --timeout=5 2>/dev/null || true
  fi

  # Poll for device existence and readability
  while (( elapsed < timeout )); do
    if [[ -b "$device_path" ]]; then
      # Device exists, verify it's readable
      if dd if="$device_path" of=/dev/null bs=1c count=1 >/dev/null 2>&1; then
        echo "Device is ready: $device_path"
        return 0
      fi
    fi
    sleep 1
    (( elapsed++ ))
  done

  echo "Warning: device did not become ready within ${timeout}s: $device_path" >&2
  return 1
}

require_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo "Error: this script must be run as root." >&2
    exit 1
  fi
}

check_blocked_host() {
  local hostname_short

  hostname_short="$(hostname -s 2>/dev/null || hostname)"
  case "$hostname_short" in
    prod10|prod60)
      echo "Error: manage_snapshot.sh is not allowed on host $hostname_short" >&2
      exit 1
      ;;
  esac
}

resolve_origin_lv() {
  local data_source vg_lv mapper_name

  data_source="$(findmnt -n -o SOURCE "$MOUNT_POINT" || true)"
  if [[ -z "$data_source" ]]; then
    echo "Error: mount point is not mounted: $MOUNT_POINT" >&2
    exit 1
  fi

  ORIGIN_SOURCE="$data_source"
  vg_lv="$(/usr/sbin/lvs --noheadings -o vg_name,lv_name "$ORIGIN_SOURCE" 2>/dev/null | awk '{$1=$1; print}')"

  if [[ -z "$vg_lv" && "$ORIGIN_SOURCE" == /dev/dm-* ]]; then
    mapper_name="$(/usr/sbin/dmsetup info -C -o name --noheadings "$ORIGIN_SOURCE" 2>/dev/null | awk '{$1=$1; print}')"
    if [[ -n "$mapper_name" ]]; then
      ORIGIN_SOURCE="/dev/mapper/$mapper_name"
      vg_lv="$(/usr/sbin/lvs --noheadings -o vg_name,lv_name "$ORIGIN_SOURCE" 2>/dev/null | awk '{$1=$1; print}')"
    fi
  fi

  if [[ -z "$vg_lv" ]]; then
    echo "Error: unable to determine VG/LV for mount source $data_source" >&2
    exit 1
  fi

  VG_NAME="$(awk '{print $1}' <<<"$vg_lv")"
  LV_NAME="$(awk '{print $2}' <<<"$vg_lv")"
  ORIGIN_LV_PATH="/dev/${VG_NAME}/${LV_NAME}"

  if [[ -z "$SNAP_NAME" ]]; then
    SNAP_NAME="${LV_NAME}_snapshot"
  fi

  SNAP_LV_PATH="/dev/${VG_NAME}/${SNAP_NAME}"
}

print_capacity() {
  VG_FREE_EXTENTS="$(/usr/sbin/vgs --noheadings -o vg_free_count "$VG_NAME" | awk '{$1=$1; print}')"
  VG_EXTENT_SIZE_MIB="$(/usr/sbin/vgs --noheadings --units m --nosuffix -o vg_extent_size "$VG_NAME" | awk '{$1=$1; printf "%.2f", $1}')"

  if [[ -z "$VG_FREE_EXTENTS" || -z "$VG_EXTENT_SIZE_MIB" ]]; then
    echo "Error: unable to determine VG capacity for $VG_NAME" >&2
    exit 1
  fi

  if ! [[ "$VG_FREE_EXTENTS" =~ ^[0-9]+$ ]]; then
    echo "Error: unexpected vg_free_count value: $VG_FREE_EXTENTS" >&2
    exit 1
  fi

  if ! [[ "$VG_RESERVE_EXTENTS" =~ ^[0-9]+$ ]]; then
    echo "Error: -r/ VG_RESERVE_EXTENTS must be a non-negative integer" >&2
    exit 1
  fi

  AVAILABLE_EXTENTS=0
  if (( VG_FREE_EXTENTS > VG_RESERVE_EXTENTS )); then
    AVAILABLE_EXTENTS=$((VG_FREE_EXTENTS - VG_RESERVE_EXTENTS))
  fi

  AVAILABLE_SNAPSHOT_MIB="$(awk -v e="$AVAILABLE_EXTENTS" -v s="$VG_EXTENT_SIZE_MIB" 'BEGIN {printf "%.2f", e*s}')"
  AVAILABLE_SNAPSHOT_GIB="$(awk -v m="$AVAILABLE_SNAPSHOT_MIB" 'BEGIN {printf "%.2f", m/1024}')"

  echo "VG free extents                    : $VG_FREE_EXTENTS"
  echo "VG extent size                     : ${VG_EXTENT_SIZE_MIB} MiB"
  echo "Usable extents after reserve ($VG_RESERVE_EXTENTS): $AVAILABLE_EXTENTS"
  echo "Approx max snapshot size available : ${AVAILABLE_SNAPSHOT_GIB} GiB"
}

create_snapshot() {
  local -a effective_args

  print_capacity

  if /usr/sbin/lvs "$SNAP_LV_PATH" >/dev/null 2>&1; then
    echo "Snapshot already exists: $SNAP_LV_PATH. Removing old snapshot..."
    /usr/sbin/lvremove -f "$SNAP_LV_PATH" 2>/dev/null || true
    sleep 2
  fi

  if [[ "${SNAP_SIZE^^}" == "AUTO" ]]; then
    if (( AVAILABLE_EXTENTS <= 0 )); then
      echo "Error: insufficient VG free extents to create snapshot." >&2
      exit 1
    fi
    effective_args=( -l "$AVAILABLE_EXTENTS" )
    echo "Auto snapshot sizing: using $AVAILABLE_EXTENTS extents"
  else
    effective_args=( -L "$SNAP_SIZE" )
  fi

  echo "Creating snapshot $SNAP_LV_PATH from $ORIGIN_LV_PATH"
  /usr/sbin/lvcreate "${effective_args[@]}" -s -n "$SNAP_NAME" "$ORIGIN_LV_PATH"

  sleep 10
  # Wait for the snapshot device to be ready
  if ! wait_for_device "$SNAP_LV_PATH" 30; then
    echo "Warning: device may not be fully ready, but proceeding anyway." >&2
  fi
}
status_snapshot() {
  local snapshot_target

  echo "Mount point   : $MOUNT_POINT"
  echo "Origin source : $ORIGIN_SOURCE"
  echo "Origin LV     : $ORIGIN_LV_PATH"
  echo "Snapshot LV   : $SNAP_LV_PATH"
  echo

  print_capacity
  echo

  if /usr/sbin/lvs "$SNAP_LV_PATH" >/dev/null 2>&1; then
    echo "Snapshot state: present"
    /usr/sbin/lvs --noheadings -o lv_name,vg_name,lv_attr,lv_size,data_percent,metadata_percent "$SNAP_LV_PATH" | awk '{$1=$1; print}'

    snapshot_target="$(findmnt -n -S "$SNAP_LV_PATH" -o TARGET || true)"
    if [[ -n "$snapshot_target" ]]; then
      echo "Snapshot mount: $snapshot_target"
    else
      echo "Snapshot mount: not mounted"
    fi
  else
    echo "Snapshot state: not present"
  fi
}

revert_snapshot() {
  local snapshot_target
  local mounted_source
  local snap_status snap_data_percent

  if ! /usr/sbin/lvs "$SNAP_LV_PATH" >/dev/null 2>&1; then
    echo "Error: snapshot not found: $SNAP_LV_PATH" >&2
    exit 1
  fi

  # Check snapshot health before attempting merge
  echo "Checking snapshot status..."
  snap_status="$(/usr/sbin/lvs -o lv_status --noheadings "$SNAP_LV_PATH" 2>/dev/null || true)"
  snap_data_percent="$(/usr/sbin/lvs -o data_percent --noheadings "$SNAP_LV_PATH" 2>/dev/null || true)"
  echo "  Status: $snap_status"
  echo "  Data %: $snap_data_percent"

  if [[ "$snap_status" == *"I"* ]]; then
    echo "WARNING: Snapshot is INVALIDATED. CoW space was exhausted." >&2
    echo "  Attempting to recover by dropping snapshot without merge..." >&2
    /usr/sbin/lvremove -f "$SNAP_LV_PATH" 2>/dev/null || true
    echo "Skipping merge since snapshot was invalidated. Origin data preserved as-is."
    return 0
  fi

  snapshot_target="$(findmnt -n -S "$SNAP_LV_PATH" -o TARGET || true)"
  if [[ -n "$snapshot_target" ]]; then
    echo "Unmounting snapshot mount: $snapshot_target"
    umount "$snapshot_target"
  fi

  if findmnt -n -M "$MOUNT_POINT" >/dev/null 2>&1; then
    echo "Unmounting origin mount: $MOUNT_POINT"
    umount -f "$MOUNT_POINT"
  
  fi

  echo "Merging snapshot $SNAP_LV_PATH back into origin"
  if ! /usr/sbin/lvconvert --merge "$SNAP_LV_PATH" 2>&1; then
    echo "ERROR: lvconvert --merge failed. Snapshot may be invalidated." >&2
    snap_status="$(/usr/sbin/lvs -o lv_status --noheadings "$SNAP_LV_PATH" 2>/dev/null || true)"
    echo "  Current snapshot status: $snap_status" >&2
    echo "  Attempting recovery by removing invalidated snapshot..." >&2
    /usr/sbin/lvremove -f "$SNAP_LV_PATH" 2>/dev/null || true
    # Continue anyway—origin data is preserved
  fi

  # Try to reactivate immediately so merge completes without reboot when possible.
  if /usr/sbin/lvchange -an "$ORIGIN_LV_PATH" 2>/dev/null; then
    /usr/sbin/lvchange -ay "$ORIGIN_LV_PATH"
  fi

  # Remove only the stale snapshot DM entry, not every device on the system.
  echo "Cleaning up stale snapshot device mapper entry..."
  local snap_dm_name
  snap_dm_name="$(echo "${VG_NAME}-${SNAP_NAME}" | tr '-' '_' | sed 's/__/-/g')"
  /usr/sbin/dmsetup remove "${snap_dm_name}" 2>/dev/null || true

  # Wait for the reactivated origin device to be ready
  if ! wait_for_device "$ORIGIN_LV_PATH" 30; then
    echo "Warning: device may not be fully ready after merge, but proceeding anyway." >&2
  fi

  if ! findmnt -n -M "$MOUNT_POINT" >/dev/null 2>&1; then
    echo "Remounting origin at $MOUNT_POINT"
    if ! mount "$MOUNT_POINT"; then
      # If mount raced and is now mounted, continue.
      if ! findmnt -n -M "$MOUNT_POINT" >/dev/null 2>&1; then
        echo "Error: failed to mount $MOUNT_POINT" >&2
        exit 1
      fi
    fi
  fi

  mounted_source="$(findmnt -n -M "$MOUNT_POINT" -o SOURCE || true)"
  if [[ -z "$mounted_source" ]]; then
    echo "Error: $MOUNT_POINT is not mounted after revert/remount." >&2
    exit 1
  fi

  if ! findmnt -n -S "$ORIGIN_LV_PATH" -o TARGET 2>/dev/null | grep -qx "$MOUNT_POINT"; then
    if ! findmnt -n -S "$ORIGIN_SOURCE" -o TARGET 2>/dev/null | grep -qx "$MOUNT_POINT"; then
      echo "Error: $MOUNT_POINT is mounted from $mounted_source, expected $ORIGIN_LV_PATH" >&2
      exit 1
    fi
  fi

  echo "Origin mounted at $MOUNT_POINT from $mounted_source"

  if ! touch "$MOUNT_POINT/.snapshot_write_test" 2>/dev/null; then
    echo "Error: $MOUNT_POINT is not writable after revert." >&2
    exit 1
  fi
  rm -f "$MOUNT_POINT/.snapshot_write_test"
}

drop_snapshot() {
  local snapshot_target

  if ! /usr/sbin/lvs "$SNAP_LV_PATH" >/dev/null 2>&1; then
    echo "Snapshot not found (already absent): $SNAP_LV_PATH"
    return 0
  fi

  snapshot_target="$(findmnt -n -S "$SNAP_LV_PATH" -o TARGET || true)"
  if [[ -n "$snapshot_target" ]]; then
    echo "Unmounting snapshot mount: $snapshot_target"
    umount "$snapshot_target"
  fi

  echo "Removing snapshot $SNAP_LV_PATH (keeping current origin data)"
  /usr/sbin/lvremove -f "$SNAP_LV_PATH"
  echo "Snapshot removed: $SNAP_LV_PATH"
}

main() {
  check_blocked_host
  require_root

  for cmd in findmnt /usr/sbin/lvs /usr/sbin/vgs /usr/sbin/lvcreate /usr/sbin/lvconvert /usr/sbin/lvchange /usr/sbin/lvremove mount umount /usr/sbin/dmsetup awk hostname; do
    require_cmd "$cmd"
  done

  case "$ACTION" in
    create|revert|drop|status)
      if [[ -z "$MOUNT_POINT" ]]; then
        echo "Error: -m <mount_point> is required." >&2
        usage
        exit 1
      fi
      resolve_origin_lv
      ;;
    help|-h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown action: $ACTION" >&2
      usage
      exit 1
      ;;
  esac

  case "$ACTION" in
    create) create_snapshot ;;
    revert) revert_snapshot ;;
    drop) drop_snapshot ;;
    status) status_snapshot ;;
  esac
}

main
