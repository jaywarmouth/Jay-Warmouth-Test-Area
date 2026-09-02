#!/bin/bash
################################################################################
# Eligibility Step 4 - Term by Exclusion Processing
#
# This script processes eligibility terminations by exclusion for configured
# clients based on their term_by_exclusion settings.
#
# Process Flow:
# 1. Validate client code parameter
# 2. Detect environment (prod10 or other)
# 3. Load appropriate configuration file
# 4. Validate client configuration and settings
# 5. Determine dates (process_date, term_date) and term_count
# 6. Create PARM file with termination parameters
# 7. Execute elgtpapull.sh (pull eligibility data)
# 8. Execute elgcrdterm.sh (process terminations)
# 9. Transfer reports if transfer_report is enabled (copy files per transfer_detail array)
#
# Usage:
#   ./eligibility_step4_process.sh <client_code> [term_date] [process_date] [term_count]
#
# Arguments:
#   client_code  - Required. Client code to process
#   term_date    - Optional. Override term_date from JSON (format: CCYYMMDD)
#   process_date - Optional. Override process_date from JSON (format: CCYYMMDD)
#   term_count   - Optional. Override max_term_count from JSON
#
# Examples:
#   ./eligibility_step4_process.sh rd
#   ./eligibility_step4_process.sh rd 20251103
#   ./eligibility_step4_process.sh rd 20251103 20251103
#   ./eligibility_step4_process.sh rd 20251103 20251103 500
#
################################################################################

################################################################################
# Configuration and Constants
################################################################################

SCRIPT_DIR="/usr/lnk/shell"
CONFIG_DIR="/usr/lnk/obj/config"
LOG_DIR="/usr/lnk/audit/batch_elig"
PARM_FOLDER=""  # Will be set by detect_environment()

# Ensure required directories exist
mkdir -p "$LOG_DIR"

################################################################################
# Utility Functions
################################################################################

get_current_date() {
    date +"%Y%m%d"
}

################################################################################
# Dependency Validation
################################################################################

check_dependencies() {
    echo "[INFO] Checking dependencies..."
    
    # Check for jq
    if ! command -v jq &> /dev/null; then
        echo "[ERROR] jq is required but not installed. Please install jq."
        exit 1
    fi
    
    # Check for required scripts
    if [ ! -f "$SCRIPT_DIR/elgtpapull.sh" ]; then
        echo "[ERROR] elgtpapull.sh not found in $SCRIPT_DIR"
        exit 1
    fi
    
    if [ ! -f "$SCRIPT_DIR/elgcrdterm.sh" ]; then
        echo "[ERROR] elgcrdterm.sh not found in $SCRIPT_DIR"
        exit 1
    fi
    
    echo "[SUCCESS] All dependencies found"
}

validate_client_config() {
    local client_code="$1"
    local client_config="$2"
    
    # Check if client has term_by_exclusion configuration
    local term_config=$(echo "$client_config" | jq -r '.term_by_exclusion')
    
    if [ "$term_config" = "null" ]; then
        echo "[WARNING] Client $client_code does not have term_by_exclusion configuration. Skipping."
        return 1
    fi
    
    # Check if enabled
    local enabled=$(echo "$term_config" | jq -r '.enabled')
    if [ "$enabled" != "true" ]; then
        echo "[INFO] Client $client_code term_by_exclusion is not enabled. Skipping."
        return 1
    fi
    
    # Check if on hold
    local hold=$(echo "$term_config" | jq -r '.hold')
    if [ "$hold" = "true" ]; then
        echo "[WARNING] Client $client_code is on hold. Skipping."
        return 1
    fi
    
    return 0
}

################################################################################
# Environment and Configuration Functions
################################################################################

detect_environment() {
    echo "[INFO] Detecting environment..." >&2
    
    # Check hostname to determine environment
    if [[ "$HOSTNAME" == "prod10.pdmboardman.local" ]]; then
        env="prod10"
        PARM_FOLDER="/usr/lnk/wt/oper-wt/elig/ELIG_PROC_PARM"
    else
        env="other"
        PARM_FOLDER="/usr/lnk/tmp"
    fi
    
    echo "[INFO] Environment detected: $env" >&2
    echo "[INFO] PARM_FOLDER set to: $PARM_FOLDER" >&2
    echo "$env"
}

################################################################################
# Load configuration
################################################################################

load_config() {
    local env="$1"
    local config_file
    
    if [ "$env" = "prod10" ]; then
        config_file="$CONFIG_DIR/batch_elig_transfer_config.json"
    else
        config_file="$CONFIG_DIR/batch_elig_transfer_config_oth.json"
    fi
    
    echo "[INFO] Loading configuration from: $config_file" >&2
    
    if [ ! -f "$config_file" ]; then
        echo "[ERROR] Config file not found: $config_file" >&2
        echo "[ERROR] Please ensure the config file is deployed to the server" >&2
        echo "[ERROR] Run deploy.sh to copy config files from the repository" >&2
        exit 1
    fi
    
    echo "$config_file"
}

################################################################################
# PARM File Creation
################################################################################

create_parm_file() {
    local sys="$1"
    local tpa="$2"
    local process_date="$3"
    local term_count="$4"
    local term_date="$5"
    
    local parm_file_name="${sys}${tpa}-${process_date}.txt"
    local parm_file="${PARM_FOLDER}/${parm_file_name}"
    
    echo "[INFO] Creating PARM file: $parm_file"
    
    # Ensure PARM folder exists
    if [ ! -d "$PARM_FOLDER" ]; then
        echo "[WARNING] PARM folder does not exist: $PARM_FOLDER"
        mkdir -p "$PARM_FOLDER"
        if [ $? -eq 0 ]; then
            echo "[SUCCESS] Created PARM folder: $PARM_FOLDER"
        else
            echo "[ERROR] Failed to create PARM folder: $PARM_FOLDER"
            return 1
        fi
    fi
    
    # PARM file format (fixed-width):
    # TPA           - 4 characters (right-padded with spaces)
    # SYSTEM-NBR    - 4 digits (left-padded with zeros)
    # FILE-CHG-DATE - 8 digits (CCYYMMDD)
    # MAX-THRESHOLD - 13 digits (left-padded with zeros)
    # TRM-DATE      - 8 digits (CCYYMMDD)
    
    # Pad TPA to 4 characters
    local tpa_padded=$(printf "%-4s" "$tpa")
    
    # Pad SYSTEM-NBR to 4 digits (force base-10 conversion by removing leading zeros)
    local sys_decimal=$((10#$sys))
    local system_nbr=$(printf "%04d" "$sys_decimal")
    
    # FILE-CHG-DATE is already 8 digits (CCYYMMDD)
    local file_chg_date="$process_date"
    
    # Pad MAX-THRESHOLD to 13 digits (force base-10 conversion)
    local count_decimal=$((10#$term_count))
    local max_threshold=$(printf "%013d" "$count_decimal")
    
    # TRM-DATE is already 8 digits (CCYYMMDD)
    local trm_date="$term_date"
    
    # Create PARM file content (total: 42 characters)
    local parm_content="${tpa_padded}${system_nbr}${file_chg_date}${max_threshold}${trm_date}"
    
    # Write to PARM file
    echo "$parm_content" > "$parm_file"
    
    if [ $? -eq 0 ]; then
        echo "[SUCCESS] PARM file created successfully: $parm_file"
        echo "[INFO] PARM content: $parm_content"
        return 0
    else
        echo "[ERROR] Failed to create PARM file: $parm_file"
        return 1
    fi
}

################################################################################
# Transfer Report Functions
################################################################################

transfer_reports() {
    local client_code="$1"
    local term_config="$2"
    
    echo "[INFO] Checking transfer_report setting for client $client_code..."
    
    # Check if transfer_report is enabled
    local transfer_report=$(echo "$term_config" | jq -r '.transfer_report')
    
    if [ "$transfer_report" != "true" ]; then
        echo "[INFO] transfer_report is not enabled for client $client_code. Skipping transfer."
        return 0
    fi
    
    echo "[INFO] transfer_report is enabled. Processing transfer_detail array..."
    
    # Get the transfer_detail array
    local transfer_detail=$(echo "$term_config" | jq -c '.transfer_detail[]')
    
    if [ -z "$transfer_detail" ]; then
        echo "[WARNING] transfer_detail array is empty for client $client_code"
        return 0
    fi
    
    # Process each source/destination pair
    local pair_count=0
    while IFS= read -r pair; do
        pair_count=$((pair_count + 1))
        
        local source=$(echo "$pair" | jq -r '.source')
        local destination=$(echo "$pair" | jq -r '.destination')
        
        # Skip if source or destination is empty
        if [ -z "$source" ] || [ "$source" = "" ] || [ "$source" = "null" ]; then
            echo "[WARNING] Pair #$pair_count: source is empty, skipping"
            continue
        fi
        
        if [ -z "$destination" ] || [ "$destination" = "" ] || [ "$destination" = "null" ]; then
            echo "[WARNING] Pair #$pair_count: destination is empty, skipping"
            continue
        fi
        
        echo "[INFO] Pair #$pair_count: Copying from $source to $destination"
        
        # Check if source file/directory exists (supports glob patterns)
        if ! ls $source > /dev/null 2>&1; then
            echo "[ERROR] Pair #$pair_count: Source does not exist: $source"
            continue
        fi
        
        # Move the file(s) (unquoted $source allows glob expansion)
        if mv $source "$destination"; then
            echo "[SUCCESS] Pair #$pair_count: Successfully moved $source to $destination"
        else
            echo "[ERROR] Pair #$pair_count: Failed to move $source to $destination"
        fi
    done <<< "$transfer_detail"
    
    if [ $pair_count -eq 0 ]; then
        echo "[WARNING] No valid transfer pairs found for client $client_code"
    else
        echo "[INFO] Processed $pair_count transfer pair(s) for client $client_code"
    fi
    
    return 0
}

################################################################################
# Script Execution Functions
################################################################################

execute_eligibility_scripts() {
    local client_code="$1"
    local sys="$2"
    local tpa="$3"
    local process_date="$4"
    local term_date="$5"
    local term_config="$6"
    
    # Execute elgtpapull.sh
    echo "[INFO] Executing elgtpapull.sh for client $client_code..."
    
    if bash "$SCRIPT_DIR/elgtpapull.sh" "$client_code" "$sys" "$tpa" "$process_date"; then
        echo "[SUCCESS] elgtpapull.sh completed successfully for client $client_code"
        
        # Execute elgcrdterm.sh
        echo "[INFO] Executing elgcrdterm.sh for client $client_code..."
        
        if bash "$SCRIPT_DIR/elgcrdterm.sh" "$client_code" "$sys" "$tpa" "$term_date"; then
            echo "[SUCCESS] elgcrdterm.sh completed successfully for client $client_code"
            
            # Transfer reports if enabled
            transfer_reports "$client_code" "$term_config"
            
            echo "[SUCCESS] Client $client_code processed successfully!"
            return 0
        else
            echo "[ERROR] elgcrdterm.sh failed for client $client_code"
            return 1
        fi
    else
        echo "[ERROR] elgtpapull.sh failed for client $client_code. Skipping elgcrdterm.sh."
        return 1
    fi
}

################################################################################
# Main Processing Function
################################################################################

process_client() {
    local client_code="$1"
    local config_file="$2"
    local current_date="$3"
    local override_term_date="$4"
    local override_process_date="$5"
    local override_term_count="$6"
    
    echo "[INFO] =========================================="
    echo "[INFO] Processing client: $client_code"
    echo "[INFO] =========================================="
    
    # Get client configuration
    local client_config=$(jq -r ".clients.\"$client_code\"" "$config_file")
    
    if [ "$client_config" = "null" ]; then
        echo "[ERROR] Client $client_code not found in configuration"
        return 1
    fi
    
    # Get client name for logging
    local client_name=$(echo "$client_config" | jq -r '.client_name')
    echo "[INFO] Client Name: $client_name"
    
    # Validate client configuration
    if ! validate_client_config "$client_code" "$client_config"; then
        return 0
    fi
    
    # Get term_by_exclusion configuration
    local term_config=$(echo "$client_config" | jq -r '.term_by_exclusion')
    
    # Get base values from JSON
    local process_date=$(echo "$term_config" | jq -r '.process_date')
    local term_date=$(echo "$term_config" | jq -r '.term_date')
    local term_count=$(echo "$term_config" | jq -r '.max_term_count')
    
    # Determine final process_date (override > JSON > current date)
    if [ -n "$override_process_date" ]; then
        process_date="$override_process_date"
        echo "[INFO] process_date overridden via command line: $process_date"
    elif [ "$process_date" = "00000000" ] || [ -z "$process_date" ]; then
        process_date="$current_date"
        echo "[INFO] process_date not set, using current date: $process_date"
    else
        echo "[INFO] process_date from JSON: $process_date"
    fi
    
    # Determine final term_date (override > JSON > current date)
    if [ -n "$override_term_date" ]; then
        term_date="$override_term_date"
        echo "[INFO] term_date overridden via command line: $term_date"
    elif [ "$term_date" = "00000000" ] || [ -z "$term_date" ]; then
        term_date="$current_date"
        echo "[INFO] term_date not set, using current date: $term_date"
    else
        echo "[INFO] term_date from JSON: $term_date"
    fi
    
    # Determine final term_count (override > JSON)
    if [ -n "$override_term_count" ]; then
        term_count="$override_term_count"
        echo "[INFO] max_term_count overridden via command line: $term_count"
    else
        echo "[INFO] max_term_count from JSON: $term_count"
    fi
    
    # Get other required fields
    local sys=$(echo "$client_config" | jq -r '.sys')
    local tpa=$(echo "$client_config" | jq -r '.tpa')
    
    echo "[INFO] System: $sys"
    echo "[INFO] TPA: $tpa"
    
    # Create PARM file
    if ! create_parm_file "$sys" "$tpa" "$process_date" "$term_count" "$term_date"; then
        return 1
    fi
    
    # Execute eligibility scripts (pass term_config for transfer_reports)
    execute_eligibility_scripts "$client_code" "$sys" "$tpa" "$process_date" "$term_date" "$term_config"
    return $?
}

################################################################################
# Get eligible clients
################################################################################

get_eligible_clients() {
    local config_file="$1"
    
    # Get all client codes where term_by_exclusion.enabled=true and hold=false
    jq -r '.clients | to_entries[] | select(.value.term_by_exclusion.enabled == true and .value.term_by_exclusion.hold == false) | .key' "$config_file"
}

################################################################################
# Main Entry Point
################################################################################

main() {
    echo "================================================================================"
    echo "Eligibility Step 4 - Term by Exclusion Processing"
    echo "Started at: $(date)"
    echo "================================================================================"
    echo ""
    
    # Validate required parameter
    if [ -z "$1" ]; then
        echo "[ERROR] Client code is required"
        echo ""
        echo "Usage: $0 <client_code> [term_date] [process_date] [term_count]"
        echo ""
        echo "Arguments:"
        echo "  client_code  - Required. Client code to process"
        echo "  term_date    - Optional. Override term_date from JSON (format: CCYYMMDD)"
        echo "  process_date - Optional. Override process_date from JSON (format: CCYYMMDD)"
        echo "  term_count   - Optional. Override max_term_count from JSON"
        echo ""
        echo "Examples:"
        echo "  $0 rd"
        echo "  $0 rd 20251103 20251103 500"
        exit 1
    fi
    
    # Parse command-line arguments
    local client_code="$1"
    local override_term_date="$2"
    local override_process_date="$3"
    local override_term_count="$4"
    
    # Check dependencies
    check_dependencies
    
    # Detect environment (sets global PARM_FOLDER)
    detect_environment > /dev/null
    local env
    if [[ "$HOSTNAME" == "prod10.pdmboardman.local" ]]; then
        env="prod10"
    else
        env="other"
    fi
    
    # Load configuration
    local config_file=$(load_config "$env")
    
    # Get current date
    local current_date=$(get_current_date)
    echo "[INFO] Current Date (CCYYMMDD): $current_date"
    
    # Process the client
    process_client "$client_code" "$config_file" "$current_date" "$override_term_date" "$override_process_date" "$override_term_count"
    local exit_code=$?
    
    echo ""
    echo "================================================================================"
    echo "Completed at: $(date)"
    echo "================================================================================"
    
    exit $exit_code
}

# Run main function
main "$@"
