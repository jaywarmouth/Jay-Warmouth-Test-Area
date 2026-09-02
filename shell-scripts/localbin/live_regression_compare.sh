#!/usr/bin/env bash
set -euo pipefail

HOSTNAME_SHORT="$(hostname -s 2>/dev/null || hostname)"

case "$HOSTNAME_SHORT" in
  prod10|prod60)
    echo "Host $HOSTNAME_SHORT is excluded. Exiting."
    exit 0
    ;;
esac

REMOTE_HOST="prod10-reg-live-cur"
REMOTE_USER="root"

CANIDATE_DIR="/data/rxconnect/compu05_rxconnect"
CURRENT_DIR="/data/rxconnect/compu05_rxconnect"

CONFIG_DIR="/usr/local/etc/live_regression_compare"
WORK_DIR="/tmp/live_regression_compare"
CURRENT_COPY_DIR="$WORK_DIR/current"
LOG_DIR="$WORK_DIR/logs"
IDENTICIAL_DIR="$LOG_DIR/identicial"
PROCESSED_CANIDATE_DIR="$WORK_DIR/canidate"
STATE_DIR="$WORK_DIR/processed"
TMP_DIR="$WORK_DIR/tmp"

RULE_CHANGES_FILE="$CONFIG_DIR/rule_changes.txt"
COMPARE_LOG="$WORK_DIR/compared_files.log"
ERROR_LOG="$WORK_DIR/errors.log"

OLLAMA_URL="http://lama50:11434/api/generate"
OLLAMA_MODEL="live-regression-compare"

GIT_COMMIT_FILE="/usr/lnk/lst/git_commit.txt"
S3_BUCKET="s3://pdmi-qa-live-regression"
AWS_S3_CP_OPTS="--only-show-errors --no-progress --sse=AES256"

RULE_CONTEXT_FIELDS=(
  "RTC-SPONSOR-NUMBER"
  "RTC-SYSTEM-NUMBER"
  "RTC-GROUP-NUMBER"
  "RTC-UID"
)

mkdir -p "$CURRENT_COPY_DIR" "$LOG_DIR" "$IDENTICIAL_DIR" "$PROCESSED_CANIDATE_DIR" "$STATE_DIR" "$TMP_DIR"

read_s3_base_dir() {
  local token

  [[ -f "$GIT_COMMIT_FILE" ]] || return 1

  token="$(awk 'NF {print $1; exit}' "$GIT_COMMIT_FILE")"
  [[ -n "$token" ]] || return 1

  printf '%s' "$token"
}

lockfile="/tmp/live_regression_compare.lock"
exec 9>"$lockfile"
flock -n 9 || exit 0

now_ts() {
  date +%s
}

print_duration() {
  local label="$1"
  local start_ts="$2"
  local end_ts elapsed

  end_ts="$(now_ts)"
  elapsed=$((end_ts - start_ts))

  echo "$(date '+%F %T') | DURATION | $label: ${elapsed}s"
}

RUN_START_TS="$(now_ts)"

log_error() {
  echo "$(date '+%F %T') | $*" >> "$ERROR_LOG"
}

upload_log_to_s3() {
  local logfile="$1"
  local relpath
  local s3_base_dir

  [[ -f "$logfile" ]] || return 0

  if ! s3_base_dir="$(read_s3_base_dir)"; then
    log_error "Failed to resolve S3 base dir from $GIT_COMMIT_FILE"
    return 0
  fi

  relpath="${logfile#$LOG_DIR/}"

  (
    /usr/local/bin/aws s3 cp \
      $AWS_S3_CP_OPTS \
      "$logfile" \
      "$S3_BUCKET/$s3_base_dir/logs/$relpath" \
      >>"$COMPARE_LOG" 2>>"$ERROR_LOG" || \
      log_error "Failed S3 upload: $logfile"
  ) &
}

upload_identical_to_s3() {
  local identical_file="$1"
  local relpath
  local s3_base_dir

  [[ -f "$identical_file" ]] || return 0

  if ! s3_base_dir="$(read_s3_base_dir)"; then
    log_error "Failed to resolve S3 base dir from $GIT_COMMIT_FILE"
    return 0
  fi

  relpath="${identical_file#$IDENTICIAL_DIR/}"

  (
    /usr/local/bin/aws s3 cp \
      $AWS_S3_CP_OPTS \
      "$identical_file" \
      "$S3_BUCKET/$s3_base_dir/identical/$relpath" \
      >>"$COMPARE_LOG" 2>>"$ERROR_LOG" || \
      log_error "Failed S3 upload (identical): $identical_file"
  ) &
}

move_canidate_file() {
  local relfile="$1"
  local source_file="$CANIDATE_DIR/$relfile"
  local destination_file="$PROCESSED_CANIDATE_DIR/$relfile"

  [[ -f "$source_file" ]] || return 0

  mkdir -p "$(dirname "$destination_file")"

  if ! mv "$source_file" "$destination_file" 2>>"$ERROR_LOG"; then
    log_error "Failed to move CANIDATE file: $relfile"
  fi
}

make_state_name() {
  printf '%s' "$1" | sha256sum | awk '{print $1}'
}

pad_number() {
  local value="$1"
  local width="$2"

  value="$(printf '%s' "$value" | sed 's/^0*//;s/^$/0/')"
  printf "%0${width}d" "$value"
}

extract_field() {
  local file="$1"
  local field="$2"

  jq -r --arg field "$field" '
    def find_key(k):
      if type == "object" then
        if has(k) then .[k]
        else [ .[] | find_key(k) ] | map(select(. != null)) | first end
      elif type == "array" then
        [ .[] | find_key(k) ] | map(select(. != null)) | first
      else
        null
      end;

    find_key($field) // ""
  ' "$file" 2>/dev/null
}

extract_many_fields() {
  local file="$1"
  shift

  python3 - "$file" "$@" <<'PY'
import json
import sys

path = sys.argv[1]
fields = sys.argv[2:]

try:
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        data = json.load(f)
except Exception:
    for _ in fields:
        print("")
    sys.exit(0)

def find_key(node, key):
    if isinstance(node, dict):
        if key in node and node[key] is not None:
            return node[key]
        for value in node.values():
            result = find_key(value, key)
            if result is not None:
                return result
    elif isinstance(node, list):
        for value in node:
            result = find_key(value, key)
            if result is not None:
                return result
    return None

for field in fields:
    value = find_key(data, field)
    if value is None:
        print("")
    elif isinstance(value, bool):
        print("true" if value else "false")
    elif isinstance(value, (dict, list)):
        print(json.dumps(value, sort_keys=True, separators=(",", ":")))
    else:
        print(value)
PY
}

write_header() {
  local canidate_file="$1"
  local current_file="$2"
  local output_file="$3"

    local -a header_fields=(
    "RTC-BATCH-YEAR"
    "RTC-BATCH-MONTH"
    "RTC-BATCH-DAY"
    "RTC-BATCH-KEYPUNCH"
    "RTC-BATCH-NUMBER"
    "RTC-CLAIM-NUMBER"
    "RTC-CARD-ID-SENT-FROM-PHARM"
    "RTC-CARDHOLDER-NUMBER"
    "RTC-SYSTEM-NUMBER"
    "RTC-SPONSOR-NUMBER"
    "RTC-GROUP-NUMBER"
    "RTC-UID"
    "RTC-RX-NUMBER"
    "RTC-RX-CENTURY"
    "RTC-RX-YEAR"
    "RTC-RX-MONTH"
    "RTC-RX-DAY"
    "RTC-NDC-1"
    "RTC-NDC-2"
    "RTC-NDC-3"
    )

    local -a c_vals cur_vals
    mapfile -t c_vals < <(extract_many_fields "$canidate_file" "${header_fields[@]}")
    mapfile -t cur_vals < <(extract_many_fields "$current_file" "${header_fields[@]}")

  local c_batch_year cur_batch_year
  local c_batch_month cur_batch_month
  local c_batch_day cur_batch_day
  local c_batch_keypunch cur_batch_keypunch
  local c_batch_number cur_batch_number
  local c_claim_number cur_claim_number

  local c_bnc cur_bnc
  local c_cardid cur_cardid
  local c_cardholder cur_cardholder
  local c_system_number cur_system_number
  local c_sponsor_number cur_sponsor_number
  local c_group_number cur_group_number
  local c_uid cur_uid
  local c_rxnumber cur_rxnumber
  local c_rxdate cur_rxdate
  local c_ndc cur_ndc

  c_batch_year="${c_vals[0]:-}"
  cur_batch_year="${cur_vals[0]:-}"

  c_batch_month="${c_vals[1]:-}"
  cur_batch_month="${cur_vals[1]:-}"

  c_batch_day="${c_vals[2]:-}"
  cur_batch_day="${cur_vals[2]:-}"

  c_batch_keypunch="${c_vals[3]:-}"
  cur_batch_keypunch="${cur_vals[3]:-}"

  c_batch_number="$(pad_number "${c_vals[4]:-}" 3)"
  cur_batch_number="$(pad_number "${cur_vals[4]:-}" 3)"

  c_claim_number="$(pad_number "${c_vals[5]:-}" 6)"
  cur_claim_number="$(pad_number "${cur_vals[5]:-}" 6)"

  c_bnc="${c_batch_year}${c_batch_month}${c_batch_day}${c_batch_keypunch}${c_batch_number}${c_claim_number}"
  cur_bnc="${cur_batch_year}${cur_batch_month}${cur_batch_day}${cur_batch_keypunch}${cur_batch_number}${cur_claim_number}"

  c_cardid="${c_vals[6]:-}"
  cur_cardid="${cur_vals[6]:-}"

  c_cardholder="${c_vals[7]:-}"
  cur_cardholder="${cur_vals[7]:-}"

  c_system_number="${c_vals[8]:-}"
  cur_system_number="${cur_vals[8]:-}"

  c_sponsor_number="${c_vals[9]:-}"
  cur_sponsor_number="${cur_vals[9]:-}"

  c_group_number="${c_vals[10]:-}"
  cur_group_number="${cur_vals[10]:-}"

  c_uid="${c_vals[11]:-}"
  cur_uid="${cur_vals[11]:-}"

  c_rxnumber="${c_vals[12]:-}"
  cur_rxnumber="${cur_vals[12]:-}"

  c_rxdate="${c_vals[13]:-}${c_vals[14]:-}${c_vals[15]:-}${c_vals[16]:-}"
  cur_rxdate="${cur_vals[13]:-}${cur_vals[14]:-}${cur_vals[15]:-}${cur_vals[16]:-}"

  c_ndc="${c_vals[17]:-}${c_vals[18]:-}${c_vals[19]:-}"
  cur_ndc="${cur_vals[17]:-}${cur_vals[18]:-}${cur_vals[19]:-}"

  {
    echo "============================================================"
    echo "LIVE REGRESSION COMPARISON HEADER"
    echo "============================================================"
    echo

    local prescription_mismatch=0

    [[ "$c_cardid" != "$cur_cardid" ]] && prescription_mismatch=1
    [[ "$c_cardholder" != "$cur_cardholder" ]] && prescription_mismatch=1
    [[ "$c_system_number" != "$cur_system_number" ]] && prescription_mismatch=1
    [[ "$c_sponsor_number" != "$cur_sponsor_number" ]] && prescription_mismatch=1
    [[ "$c_group_number" != "$cur_group_number" ]] && prescription_mismatch=1
    [[ "$c_uid" != "$cur_uid" ]] && prescription_mismatch=1
    [[ "$c_rxnumber" != "$cur_rxnumber" ]] && prescription_mismatch=1
    [[ "$c_rxdate" != "$cur_rxdate" ]] && prescription_mismatch=1
    [[ "$c_ndc" != "$cur_ndc" ]] && prescription_mismatch=1

    if (( prescription_mismatch )); then
      echo "WARNING: This transaction may be for a different prescription."
      echo
      echo "Mismatched prescription identity fields:"

      [[ "$c_cardid" != "$cur_cardid" ]] && echo "- RTC-CARD-ID-SENT-FROM-PHARM"
      [[ "$c_cardholder" != "$cur_cardholder" ]] && echo "- RTC-CARDHOLDER-NUMBER"
      [[ "$c_system_number" != "$cur_system_number" ]] && echo "- RTC-SYSTEM-NUMBER"
      [[ "$c_sponsor_number" != "$cur_sponsor_number" ]] && echo "- RTC-SPONSOR-NUMBER"
      [[ "$c_group_number" != "$cur_group_number" ]] && echo "- RTC-GROUP-NUMBER"
      [[ "$c_uid" != "$cur_uid" ]] && echo "- RTC-UID"
      [[ "$c_rxnumber" != "$cur_rxnumber" ]] && echo "- RTC-RX-NUMBER"
      [[ "$c_rxdate" != "$cur_rxdate" ]] && echo "- RXDATE"
      [[ "$c_ndc" != "$cur_ndc" ]] && echo "- NDC"

      echo
    fi

    echo "BNC"
    echo "  CANIDATE: ${c_bnc:-<missing/blank>}"
    echo "  CURRENT : ${cur_bnc:-<missing/blank>}"
    echo

    echo "RTC-CARD-ID-SENT-FROM-PHARM"
    echo "  CANIDATE: ${c_cardid:-<missing/blank>}"
    echo "  CURRENT : ${cur_cardid:-<missing/blank>}"
    echo

    echo "RTC-CARDHOLDER-NUMBER"
    echo "  CANIDATE: ${c_cardholder:-<missing/blank>}"
    echo "  CURRENT : ${cur_cardholder:-<missing/blank>}"
    echo

    echo "RTC-SYSTEM-NUMBER"
    echo "  CANIDATE: ${c_system_number:-<missing/blank>}"
    echo "  CURRENT : ${cur_system_number:-<missing/blank>}"
    echo

    echo "RTC-SPONSOR-NUMBER"
    echo "  CANIDATE: ${c_sponsor_number:-<missing/blank>}"
    echo "  CURRENT : ${cur_sponsor_number:-<missing/blank>}"
    echo

    echo "RTC-GROUP-NUMBER"
    echo "  CANIDATE: ${c_group_number:-<missing/blank>}"
    echo "  CURRENT : ${cur_group_number:-<missing/blank>}"
    echo

    echo "RTC-UID"
    echo "  CANIDATE: ${c_uid:-<missing/blank>}"
    echo "  CURRENT : ${cur_uid:-<missing/blank>}"
    echo

    echo "RTC-RX-NUMBER"
    echo "  CANIDATE: ${c_rxnumber:-<missing/blank>}"
    echo "  CURRENT : ${cur_rxnumber:-<missing/blank>}"
    echo

    echo "RXDATE"
    echo "  CANIDATE: ${c_rxdate:-<missing/blank>}"
    echo "  CURRENT : ${cur_rxdate:-<missing/blank>}"
    echo

    echo "NDC"
    echo "  CANIDATE: ${c_ndc:-<missing/blank>}"
    echo "  CURRENT : ${cur_ndc:-<missing/blank>}"
    echo

    echo "============================================================"
    echo
  } > "$output_file"
}

write_missing_current_header() {
  local canidate_file="$1"
  local output_file="$2"

  local -a header_fields=(
    "RTC-BATCH-YEAR"
    "RTC-BATCH-MONTH"
    "RTC-BATCH-DAY"
    "RTC-BATCH-KEYPUNCH"
    "RTC-BATCH-NUMBER"
    "RTC-CLAIM-NUMBER"
    "RTC-CARD-ID-SENT-FROM-PHARM"
    "RTC-CARDHOLDER-NUMBER"
    "RTC-SYSTEM-NUMBER"
    "RTC-SPONSOR-NUMBER"
    "RTC-GROUP-NUMBER"
    "RTC-UID"
    "RTC-RX-NUMBER"
    "RTC-RX-CENTURY"
    "RTC-RX-YEAR"
    "RTC-RX-MONTH"
    "RTC-RX-DAY"
    "RTC-NDC-1"
    "RTC-NDC-2"
    "RTC-NDC-3"
  )

  local -a c_vals
  mapfile -t c_vals < <(extract_many_fields "$canidate_file" "${header_fields[@]}")

  local c_batch_year c_batch_month c_batch_day c_batch_keypunch c_batch_number c_claim_number
  local c_bnc c_cardid c_cardholder c_system_number c_sponsor_number c_group_number c_uid
  local c_rxnumber c_rxdate c_ndc

  c_batch_year="${c_vals[0]:-}"
  c_batch_month="${c_vals[1]:-}"
  c_batch_day="${c_vals[2]:-}"
  c_batch_keypunch="${c_vals[3]:-}"
  c_batch_number="$(pad_number "${c_vals[4]:-}" 3)"
  c_claim_number="$(pad_number "${c_vals[5]:-}" 6)"
  c_bnc="${c_batch_year}${c_batch_month}${c_batch_day}${c_batch_keypunch}${c_batch_number}${c_claim_number}"

  c_cardid="${c_vals[6]:-}"
  c_cardholder="${c_vals[7]:-}"
  c_system_number="${c_vals[8]:-}"
  c_sponsor_number="${c_vals[9]:-}"
  c_group_number="${c_vals[10]:-}"
  c_uid="${c_vals[11]:-}"
  c_rxnumber="${c_vals[12]:-}"
  c_rxdate="${c_vals[13]:-}${c_vals[14]:-}${c_vals[15]:-}${c_vals[16]:-}"
  c_ndc="${c_vals[17]:-}${c_vals[18]:-}${c_vals[19]:-}"

  {
    echo "============================================================"
    echo "LIVE REGRESSION COMPARISON HEADER"
    echo "============================================================"
    echo
    echo "WARNING: No matching CURRENT remote file was found."
    echo

    for field in \
      "BNC:$c_bnc" \
      "RTC-CARD-ID-SENT-FROM-PHARM:$c_cardid" \
      "RTC-CARDHOLDER-NUMBER:$c_cardholder" \
      "RTC-SYSTEM-NUMBER:$c_system_number" \
      "RTC-SPONSOR-NUMBER:$c_sponsor_number" \
      "RTC-GROUP-NUMBER:$c_group_number" \
      "RTC-UID:$c_uid" \
      "RTC-RX-NUMBER:$c_rxnumber" \
      "RXDATE:$c_rxdate" \
      "NDC:$c_ndc"; do

      name="${field%%:*}"
      value="${field#*:}"

      echo "$name"
      echo "  CANIDATE: ${value:-<missing/blank>}"
      echo "  CURRENT : <remote file missing>"
      echo
    done

    echo "============================================================"
    echo
    echo "NO MATCHING CURRENT REMOTE FILE FOUND"
  } > "$output_file"
}

write_identical_disposition() {
  local canidate_file="$1"
  local current_file="$2"
  local output_file="$3"

  local -a pricing_fields=(
    "RTC-ING-COST-BILLED"
    "RTC-ING-COST-PAID"
    "RTC-DISP-FEE"
    "RTC-COPAY"
    "RTC-AMT-APPLIED-PER-DEDUCTIBLE"
    "RTC-PATIENT-PAID-AMOUNT"
    "RTC-GROSS-AMOUNT-DUE"
    "RTC-CONTRACT-RATE-PRICE"
    "RTC-REJ-CODE-1"
    "RTC-REJ-CODE-2"
    "RTC-AMT-EXCEED-PER-BENEFIT-MAX"
    "RTC-AMT-COPAY"
    "RTC-AMT-COINSURANCE"
    "RTC-AMOUNT-APPLIED-TO-OOP"
  )

  local -a c_vals cur_vals
  mapfile -t c_vals < <(extract_many_fields "$canidate_file" "${pricing_fields[@]}")
  mapfile -t cur_vals < <(extract_many_fields "$current_file" "${pricing_fields[@]}")

  local c_ing_cost_billed="${c_vals[0]:-0.00}"
  local c_ing_cost_paid="${c_vals[1]:-0.00}"
  local c_disp_fee="${c_vals[2]:-0.00}"
  local c_copay="${c_vals[3]:-0.00}"
  local c_deductible="${c_vals[4]:-0.00}"
  local c_patient_paid="${c_vals[5]:-0.00}"
  local c_gross_amt="${c_vals[6]:-0.00}"
  local c_contract_rate="${c_vals[7]:-0.00}"
  local c_rej_code_1="${c_vals[8]:-}"
  local c_rej_code_2="${c_vals[9]:-}"
  local c_exceed_benefit_max="${c_vals[10]:-0.00}"
  local c_accum_copay="${c_vals[11]:-0.00}"
  local c_accum_coinsurance="${c_vals[12]:-0.00}"
  local c_accum_oop="${c_vals[13]:-0.00}"

  {
    echo "============================================================"
    echo "PRICING & CLAIM DISPOSITION (CLAIMS IDENTICAL)"
    echo "============================================================"
    echo
    echo "PRICING SUMMARY:"
    echo "  Ingredient Cost Billed (RTC-ING-COST-BILLED) : \$$c_ing_cost_billed"
    echo "  Ingredient Cost Paid (RTC-ING-COST-PAID) : \$$c_ing_cost_paid"
    echo "  Dispensing Fee (RTC-DISP-FEE) : \$$c_disp_fee"
    echo "  Copay Amount (RTC-COPAY) : \$$c_copay"
    echo "  Deductible Applied (RTC-AMT-APPLIED-PER-DEDUCTIBLE) : \$$c_deductible"
    echo "  Patient Paid Total (RTC-PATIENT-PAID-AMOUNT) : \$$c_patient_paid"
    echo "  ─────────────────────────────────────"
    echo "  Gross Amount Due (RTC-GROSS-AMOUNT-DUE) : \$$c_gross_amt"
    echo "  Contract Rate Price (RTC-CONTRACT-RATE-PRICE) : \$$c_contract_rate"
    echo
    echo "CLAIM STATUS:"
    echo "  Rejection Code 1 (RTC-REJ-CODE-1) : $c_rej_code_1"
    echo "  Rejection Code 2 (RTC-REJ-CODE-2) : $c_rej_code_2"
    echo
    echo "ACCUMULATOR TRACKING:"
    echo "  Benefit Max Exceeded (RTC-AMT-EXCEED-PER-BENEFIT-MAX) : \$$c_exceed_benefit_max"
    echo "  Copay Accumulation (RTC-AMT-COPAY) : \$$c_accum_copay"
    echo "  Coinsurance (RTC-AMT-COINSURANCE) : \$$c_accum_coinsurance"
    echo "  OOP Applied (RTC-AMOUNT-APPLIED-TO-OOP) : \$$c_accum_oop"
    echo
    echo "============================================================"
    echo
  } >> "$output_file"
}

create_json_value_diff() {
  local canidate_file="$1"
  local current_file="$2"
  local output_file="$3"

  python3 - "$canidate_file" "$current_file" > "$output_file" <<'PY'
import json
import sys

canidate_path = sys.argv[1]
current_path = sys.argv[2]

ignored_leaf_fields = {
    "RTC-BATCH-YEAR",
    "RTC-BATCH-MONTH",
    "RTC-BATCH-DAY",
    "RTC-BATCH-KEYPUNCH",
    "RTC-BATCH-NUMBER",
    "RTC-CLAIM-NUMBER",

    "RTC-CLAIM-ADJUDICATION-TIME",

    "RTC-LAST-MODIFIED-TIME",

    "RTC-CLD-BATCH-NUMBER",
    "RTC-CLD-CLAIM-NUMBER",

    "RTC-CSS-DATETIME-TIME",
    "RTC-CSS-BATCH-MASTER",
    "RTC-CSS-CLAIM-NUMBER",

    "RTC-CCB-BATCH-NUMBER",
    "RTC-CCB-CLAIM-NUMBER",
    "RTC-CAT-ADD-DATE",
    "RTC-CAT-CHG-DATE",
    "RTC-TIME",
}

MISSING = object()

def load_json(path):
  try:
    with open(path, "r", encoding="utf-8", errors="replace") as f:
      return json.load(f)
  except Exception as exc:
    raise RuntimeError(f"Failed to load JSON from {path}: {exc}")

def path_to_string(parts):
    out = ""
    for part in parts:
        if isinstance(part, int):
            out += f"[{part}]"
        else:
            if out:
                out += "."
            out += str(part)
    return out or "$"

def should_ignore(parts):
    return bool(parts) and str(parts[-1]) in ignored_leaf_fields

def scalar_repr(value):
    if value is MISSING:
        return "<missing>"
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, str):
        return json.dumps(value)
    return json.dumps(value, sort_keys=True, separators=(",", ":"))

def compare(path, a, b, diffs):
    if should_ignore(path):
        return

    if a is MISSING or b is MISSING:
        diffs.append((path_to_string(path), a, b))
        return

    if isinstance(a, dict) and isinstance(b, dict):
        keys = sorted(set(a.keys()) | set(b.keys()))
        for key in keys:
            compare(path + [key], a.get(key, MISSING), b.get(key, MISSING), diffs)
        return

    if isinstance(a, list) and isinstance(b, list):
        max_len = max(len(a), len(b))
        for i in range(max_len):
            av = a[i] if i < len(a) else MISSING
            bv = b[i] if i < len(b) else MISSING
            compare(path + [i], av, bv, diffs)
        return

    if type(a) != type(b) or a != b:
        diffs.append((path_to_string(path), a, b))

try:
  canidate = load_json(canidate_path)
  current = load_json(current_path)
except Exception as exc:
  print(str(exc), file=sys.stderr)
  sys.exit(1)

diffs = []
compare([], canidate, current, diffs)

for field, canidate_value, current_value in diffs:
    print(f"FIELD: {field}")
    print(f"CANIDATE: {scalar_repr(canidate_value)}")
    print(f"CURRENT: {scalar_repr(current_value)}")
    print()
PY
}

while true; do
  files_found=0

  while IFS= read -r -d '' relfile; do
    files_found=1
  file_start_ts="$(now_ts)"
  canidate_file="$CANIDATE_DIR/$relfile"
  current_file="$CURRENT_DIR/$relfile"
  local_current_file="$CURRENT_COPY_DIR/$relfile"

  state_file="$STATE_DIR/$(make_state_name "$relfile").done"
  if [[ -f "$state_file" ]]; then
    already_processed_start_ts="$(now_ts)"
    move_canidate_file "$relfile"
    print_duration "already processed move | $relfile" "$already_processed_start_ts"
    print_duration "file total | $relfile" "$file_start_ts"
    continue
  fi

  file_hash="$(make_state_name "$relfile")"

  mkdir -p "$(dirname "$local_current_file")"
  mkdir -p "$(dirname "$LOG_DIR/$relfile")"

  output_log="$LOG_DIR/$relfile.log"
  value_diff="$TMP_DIR/$file_hash.value.diff"
  prompt_file="$TMP_DIR/$file_hash.prompt.txt"
  response_json="$TMP_DIR/$file_hash.response.json"
  header_file="$TMP_DIR/$file_hash.header.txt"
  normalized_canidate="$TMP_DIR/$file_hash.canidate.normalized.json"
  normalized_current="$TMP_DIR/$file_hash.current.normalized.json"

  rsync_start_ts="$(now_ts)"
  if ! rsync -az --protect-args -e "ssh -o StrictHostKeyChecking=no -o BatchMode=yes" \
      "${REMOTE_USER}@${REMOTE_HOST}:$current_file" \
      "$local_current_file" 2>>"$ERROR_LOG"; then
    print_duration "rsync | $relfile" "$rsync_start_ts"

    log_error "Missing or failed current copy: $relfile"

    missing_current_start_ts="$(now_ts)"
    if jq -S . "$canidate_file" > "$normalized_canidate" 2>>"$ERROR_LOG"; then
      write_missing_current_header "$normalized_canidate" "$output_log"

      echo "$(date '+%F %T') | missing current remote file | $relfile" >> "$COMPARE_LOG"

      upload_log_to_s3 "$output_log"

      touch "$state_file"
      move_canidate_file "$relfile"
      print_duration "missing current handling | $relfile" "$missing_current_start_ts"
    else
      log_error "Failed to parse CANIDATE JSON while handling missing CURRENT file: $relfile"
      print_duration "missing current handling | $relfile" "$missing_current_start_ts"
    fi

    rm -f "$prompt_file" "$response_json" "$header_file" "$value_diff" "$normalized_canidate" "$normalized_current"
    print_duration "file total | $relfile" "$file_start_ts"
    continue
  fi
  print_duration "rsync | $relfile" "$rsync_start_ts"

  normalize_canidate_start_ts="$(now_ts)"
  if ! jq -S . "$canidate_file" > "$normalized_canidate" 2>>"$ERROR_LOG"; then
    log_error "Failed to parse CANIDATE JSON: $relfile"
    rm -f "$prompt_file" "$response_json" "$header_file" "$value_diff" "$normalized_canidate" "$normalized_current"
    print_duration "normalize canidate json | $relfile" "$normalize_canidate_start_ts"
    print_duration "file total | $relfile" "$file_start_ts"
    continue
  fi
  print_duration "normalize canidate json | $relfile" "$normalize_canidate_start_ts"

  normalize_current_start_ts="$(now_ts)"
  if ! jq -S . "$local_current_file" > "$normalized_current" 2>>"$ERROR_LOG"; then
    log_error "Failed to parse CURRENT JSON: $relfile"
    rm -f "$prompt_file" "$response_json" "$header_file" "$value_diff" "$normalized_canidate" "$normalized_current"
    print_duration "normalize current json | $relfile" "$normalize_current_start_ts"
    print_duration "file total | $relfile" "$file_start_ts"
    continue
  fi
  print_duration "normalize current json | $relfile" "$normalize_current_start_ts"

  diff_header_start_ts="$(now_ts)"
  write_header "$normalized_canidate" "$normalized_current" "$header_file"
  if ! create_json_value_diff "$normalized_canidate" "$normalized_current" "$value_diff" 2>>"$ERROR_LOG"; then
    log_error "Failed to create JSON value diff: $relfile"
    rm -f "$prompt_file" "$response_json" "$header_file" "$value_diff" "$normalized_canidate" "$normalized_current"
    print_duration "header and value diff | $relfile" "$diff_header_start_ts"
    print_duration "file total | $relfile" "$file_start_ts"
    continue
  fi
  print_duration "header and value diff | $relfile" "$diff_header_start_ts"

  cat "$header_file" > "$output_log"

  if [[ ! -s "$value_diff" ]]; then
    echo "NO ACTIONABLE VALUE DIFFERENCES FOUND" >> "$output_log"

    write_identical_disposition "$normalized_canidate" "$normalized_current" "$output_log"

    if [[ -s "$RULE_CHANGES_FILE" ]]; then
      echo >> "$output_log"
      echo "EXPECTED RULE CHANGES WERE PROVIDED, BUT NO ACTIONABLE DIFFERENCES WERE FOUND:" >> "$output_log"
      cat "$RULE_CHANGES_FILE" >> "$output_log"
    fi

    identicial_log="$IDENTICIAL_DIR/$relfile.log"
    mkdir -p "$(dirname "$identicial_log")"
    mv "$output_log" "$identicial_log"
    output_log="$identicial_log"

    echo "$(date '+%F %T') | no actionable differences | $relfile" >> "$COMPARE_LOG"

    upload_identical_to_s3 "$identicial_log"

    touch "$state_file"
    move_canidate_file "$relfile"

    rm -f "$prompt_file" "$response_json" "$header_file" "$value_diff" "$normalized_canidate" "$normalized_current"
    print_duration "file total | $relfile" "$file_start_ts"
    continue
  fi

  {
    echo "File name: $relfile"
    echo

    if [[ -s "$RULE_CHANGES_FILE" ]]; then
      echo "EXPECTED RULE CHANGES:"
      echo "-----BEGIN EXPECTED RULE CHANGES-----"
      cat "$RULE_CHANGES_FILE"
      echo
      echo "-----END EXPECTED RULE CHANGES-----"
      echo

      echo "RULE CONTEXT FIELDS:"
      echo "-----BEGIN RULE CONTEXT FIELDS-----"
      mapfile -t c_context_vals < <(extract_many_fields "$normalized_canidate" "${RULE_CONTEXT_FIELDS[@]}")
      mapfile -t cur_context_vals < <(extract_many_fields "$normalized_current" "${RULE_CONTEXT_FIELDS[@]}")

      for i in "${!RULE_CONTEXT_FIELDS[@]}"; do
        context_field="${RULE_CONTEXT_FIELDS[$i]}"
        cval="${c_context_vals[$i]:-}"
        curval="${cur_context_vals[$i]:-}"

        echo "FIELD: $context_field"
        echo "CANIDATE: ${cval:-<missing/blank>}"
        echo "CURRENT: ${curval:-<missing/blank>}"
        echo
      done
      echo "-----END RULE CONTEXT FIELDS-----"
      echo
    fi

    echo "DETECTED JSON VALUE DIFFERENCES:"
    echo "-----BEGIN DIFFERENCES-----"
    cat "$value_diff"
    echo "-----END DIFFERENCES-----"
  } > "$prompt_file"

  ollama_start_ts="$(now_ts)"
  if jq -n \
      --arg model "$OLLAMA_MODEL" \
      --rawfile prompt "$prompt_file" \
      '{model:$model,prompt:$prompt,stream:false}' |
      curl -sS "$OLLAMA_URL" \
        -H "Content-Type: application/json" \
        -d @- > "$response_json"; then
    print_duration "ollama request | $relfile" "$ollama_start_ts"

    {
      echo
      echo "============================================================"
      echo "ACTIONABLE DIFFERENCE ANALYSIS"
      echo "============================================================"
      jq -r '.response // .' "$response_json"
    } >> "$output_log"

    echo "$(date '+%F %T') | compared | $relfile" >> "$COMPARE_LOG"

    upload_log_to_s3 "$output_log"

    touch "$state_file"
    move_canidate_file "$relfile"
  else
    print_duration "ollama request | $relfile" "$ollama_start_ts"
    log_error "Ollama request failed: $relfile"
  fi

  rm -f "$prompt_file" "$response_json" "$header_file" "$value_diff" "$normalized_canidate" "$normalized_current"
  print_duration "file total | $relfile" "$file_start_ts"
  done < <(find "$CANIDATE_DIR" -type f -mmin +1 -printf '%P\0')

  if (( files_found == 0 )); then
    upload_wait_start_ts="$(now_ts)"
    wait || true
    print_duration "background upload wait" "$upload_wait_start_ts"
    echo "$(date '+%F %T') | INFO | no files to process; sleeping 5s"
    sleep 5
  fi
done
