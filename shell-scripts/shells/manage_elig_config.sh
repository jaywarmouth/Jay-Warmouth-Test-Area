#!/bin/bash
################################################################################
# Batch Eligibility Transfer Config Manager
# 
# This script provides utilities to update, delete, and insert entries in
# batch_elig_transfer_config.json or batch_elig_transfer_config_oth.json
#
# Usage:
#   ./manage_elig_config.sh [--config prod|other] <command> [options]
#
# Options:
#   --config prod|other    Specify which config file to use (default: auto-detect from hostname)
#
# Commands:
#   update-field       Update a field for one or all clients
#   delete-field       Delete a field from one or all clients
#   insert-client      Insert a new client entry
#   delete-client      Delete a client entry
#   enable-client      Enable a client
#   disable-client     Disable a client
#   set-hold           Set hold flag for term_by_exclusion
#   clear-hold         Clear hold flag for term_by_exclusion
#   update-dates       Update process_date and term_date
#   list-clients       List all client codes
#   show-client        Show configuration for a specific client
#   backup             Create a backup of the config file
#   restore            Restore from backup
#
################################################################################

# Detect environment and set config file
detect_config_file() {
    if [[ "$HOSTNAME" == "prod10.pdmboardman.local" ]]; then
        echo "/usr/lnk/obj/config/batch_elig_transfer_config.json"
    else
        echo "/usr/lnk/obj/config/batch_elig_transfer_config_oth.json"
    fi
}

# Parse --config option if provided
CONFIG_FILE=""
if [[ "$1" == "--config" ]]; then
    shift
    if [[ "$1" == "prod" ]]; then
        CONFIG_FILE="/usr/lnk/obj/config/batch_elig_transfer_config.json"
    elif [[ "$1" == "other" ]]; then
        CONFIG_FILE="/usr/lnk/obj/config/batch_elig_transfer_config_oth.json"
    else
        echo "Error: Invalid config option. Use 'prod' or 'other'"
        exit 1
    fi
    shift
fi

# Auto-detect if not specified
if [[ -z "$CONFIG_FILE" ]]; then
    CONFIG_FILE=$(detect_config_file)
fi

BACKUP_DIR="/usr/lnk/tmp"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure jq is available
check_jq() {
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq is required but not installed.${NC}"
        echo "Please install jq: https://stedolan.github.io/jq/"
        exit 1
    fi
    
    # Display which config file is being used
    echo -e "${BLUE}Using config file: $CONFIG_FILE${NC}"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}Error: Config file not found: $CONFIG_FILE${NC}"
        exit 1
    fi
    
    # Check for UTF-16 BOM and convert if necessary
    local first_bytes=$(xxd -l 2 -p "$CONFIG_FILE" 2>/dev/null)
    if [[ "$first_bytes" == "fffe" || "$first_bytes" == "feff" ]]; then
        echo -e "${YELLOW}Warning: File is UTF-16 encoded. Converting to UTF-8...${NC}"
        local temp_file="${CONFIG_FILE}.utf8.tmp"
        if command -v iconv &> /dev/null; then
            iconv -f UTF-16 -t UTF-8 "$CONFIG_FILE" > "$temp_file"
            mv "$temp_file" "$CONFIG_FILE"
            echo -e "${GREEN}Conversion complete.${NC}"
        else
            echo -e "${RED}Error: iconv is required to convert UTF-16 to UTF-8${NC}"
            echo "Please run: iconv -f UTF-16 -t UTF-8 $CONFIG_FILE > ${CONFIG_FILE}.utf8 && mv ${CONFIG_FILE}.utf8 $CONFIG_FILE"
            exit 1
        fi
    fi
    
    # Validate JSON syntax
    if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
        echo -e "${RED}Error: Invalid JSON in config file${NC}"
        echo -e "${YELLOW}Attempting to identify the issue...${NC}"
        # Show the first few bytes to check for BOM or other issues
        echo "First 20 bytes (hex):"
        xxd -l 20 "$CONFIG_FILE"
        echo ""
        echo "Trying to parse JSON:"
        jq empty "$CONFIG_FILE"
        exit 1
    fi
}

# Create backup
backup_config() {
    mkdir -p "$BACKUP_DIR"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/batch_elig_transfer_config_${timestamp}.json"
    cp "$CONFIG_FILE" "$backup_file"
    echo -e "${GREEN}Backup created: $backup_file${NC}"
}

# Update a field for one or all clients
update_field() {
    local client_code="$1"
    local field_path="$2"
    local new_value="$3"
    
    if [ -z "$client_code" ] || [ -z "$field_path" ] || [ -z "$new_value" ]; then
        echo -e "${RED}Usage: $0 update-field <client_code|ALL> <field_path> <value>${NC}"
        echo "Example: $0 update-field rd term_by_exclusion.enabled true"
        echo "Example: $0 update-field ALL term_by_exclusion.hold false"
        exit 1
    fi
    
    backup_config
    
    if [ "$client_code" = "ALL" ]; then
        # Update all clients
        local temp_file=$(mktemp)
        jq ".clients |= with_entries(.value.$field_path = $new_value)" "$CONFIG_FILE" > "$temp_file"
        mv "$temp_file" "$CONFIG_FILE"
        echo -e "${GREEN}Updated field '$field_path' for ALL clients${NC}"
    else
        # Update specific client
        local temp_file=$(mktemp)
        jq ".clients.\"$client_code\".$field_path = $new_value" "$CONFIG_FILE" > "$temp_file"
        mv "$temp_file" "$CONFIG_FILE"
        echo -e "${GREEN}Updated field '$field_path' for client '$client_code'${NC}"
    fi
}

# Delete a field from one or all clients
delete_field() {
    local client_code="$1"
    local field_path="$2"
    
    if [ -z "$client_code" ] || [ -z "$field_path" ]; then
        echo -e "${RED}Usage: $0 delete-field <client_code|ALL> <field_path>${NC}"
        echo "Example: $0 delete-field rd term_by_exclusion.description"
        echo "Example: $0 delete-field ALL destinations"
        exit 1
    fi
    
    backup_config
    
    if [ "$client_code" = "ALL" ]; then
        # Delete from all clients
        local temp_file=$(mktemp)
        jq ".clients |= with_entries(del(.value.$field_path))" "$CONFIG_FILE" > "$temp_file"
        mv "$temp_file" "$CONFIG_FILE"
        echo -e "${GREEN}Deleted field '$field_path' from ALL clients${NC}"
    else
        # Delete from specific client
        local temp_file=$(mktemp)
        jq "del(.clients.\"$client_code\".$field_path)" "$CONFIG_FILE" > "$temp_file"
        mv "$temp_file" "$CONFIG_FILE"
        echo -e "${GREEN}Deleted field '$field_path' from client '$client_code'${NC}"
    fi
}

# Insert a new client
insert_client() {
    local client_code="$1"
    local template_file="$2"
    
    if [ -z "$client_code" ]; then
        echo -e "${RED}Usage: $0 insert-client <client_code> [template_file]${NC}"
        echo "If template_file is not provided, a default template will be used"
        exit 1
    fi
    
    # Check if client already exists
    if jq -e ".clients.\"$client_code\"" "$CONFIG_FILE" > /dev/null 2>&1; then
        echo -e "${RED}Error: Client '$client_code' already exists${NC}"
        exit 1
    fi
    
    backup_config
    
    if [ -n "$template_file" ] && [ -f "$template_file" ]; then
        # Use provided template
        local client_data=$(cat "$template_file")
    else
        # Use default template
        local client_data='{
      "client_name": "NEW_CLIENT",
      "tpa": "n/a",
      "enabled": false,
      "sys": "0000",
      "elig_type": "1",
      "grp_flg": "0",
      "rpt_name": "NEW",
      "program_name": "cardh29",
      "proc_flg": "0",
      "tr_method": "GA",
      "acct_name": "new-client",
      "frequency": "D",
      "status": "A",
      "term_by_exclusion": {
        "enabled": true,
        "hold": false,
        "process_date": "00000000",
        "term_date": "00000000",
        "max_term_count": "0000000000500"
      },
      "destinations": {
        "aws_s3": {
          "bucket_name": "",
          "prefix": "",
          "formats": {
            "PRINT29": ["txt"],
            "CA29": ["pdf"]
          }
        }
      }
    }'
    fi
    
    local temp_file=$(mktemp)
    jq ".clients.\"$client_code\" = $client_data" "$CONFIG_FILE" > "$temp_file"
    mv "$temp_file" "$CONFIG_FILE"
    echo -e "${GREEN}Inserted new client '$client_code'${NC}"
    echo -e "${YELLOW}Note: Please update the client configuration manually${NC}"
}

# Delete a client
delete_client() {
    local client_code="$1"
    
    if [ -z "$client_code" ]; then
        echo -e "${RED}Usage: $0 delete-client <client_code>${NC}"
        exit 1
    fi
    
    # Check if client exists
    if ! jq -e ".clients.\"$client_code\"" "$CONFIG_FILE" > /dev/null 2>&1; then
        echo -e "${RED}Error: Client '$client_code' does not exist${NC}"
        exit 1
    fi
    
    backup_config
    
    local temp_file=$(mktemp)
    jq "del(.clients.\"$client_code\")" "$CONFIG_FILE" > "$temp_file"
    mv "$temp_file" "$CONFIG_FILE"
    echo -e "${GREEN}Deleted client '$client_code'${NC}"
}

# Enable a client
enable_client() {
    local client_code="$1"
    
    if [ -z "$client_code" ]; then
        echo -e "${RED}Usage: $0 enable-client <client_code|ALL>${NC}"
        exit 1
    fi
    
    update_field "$client_code" "enabled" "true"
}

# Disable a client
disable_client() {
    local client_code="$1"
    
    if [ -z "$client_code" ]; then
        echo -e "${RED}Usage: $0 disable-client <client_code|ALL>${NC}"
        exit 1
    fi
    
    update_field "$client_code" "enabled" "false"
}

# Set hold flag for term_by_exclusion
set_hold() {
    local client_code="$1"
    
    if [ -z "$client_code" ]; then
        echo -e "${RED}Usage: $0 set-hold <client_code|ALL>${NC}"
        exit 1
    fi
    
    update_field "$client_code" "term_by_exclusion.hold" "true"
}

# Clear hold flag for term_by_exclusion
clear_hold() {
    local client_code="$1"
    
    if [ -z "$client_code" ]; then
        echo -e "${RED}Usage: $0 clear-hold <client_code|ALL>${NC}"
        exit 1
    fi
    
    update_field "$client_code" "term_by_exclusion.hold" "false"
}

# Update process_date and term_date
update_dates() {
    local client_code="$1"
    local process_date="$2"
    local term_date="$3"
    
    if [ -z "$client_code" ] || [ -z "$process_date" ]; then
        echo -e "${RED}Usage: $0 update-dates <client_code|ALL> <process_date> [term_date]${NC}"
        echo "Example: $0 update-dates rd 20251103 20251104"
        echo "If term_date is not provided, it will use the same as process_date"
        exit 1
    fi
    
    if [ -z "$term_date" ]; then
        term_date="$process_date"
    fi
    
    backup_config
    
    if [ "$client_code" = "ALL" ]; then
        local temp_file=$(mktemp)
        jq ".clients |= with_entries(.value.term_by_exclusion.process_date = \"$process_date\" | .value.term_by_exclusion.term_date = \"$term_date\")" "$CONFIG_FILE" > "$temp_file"
        mv "$temp_file" "$CONFIG_FILE"
        echo -e "${GREEN}Updated dates for ALL clients${NC}"
    else
        local temp_file=$(mktemp)
        jq ".clients.\"$client_code\".term_by_exclusion.process_date = \"$process_date\" | .clients.\"$client_code\".term_by_exclusion.term_date = \"$term_date\"" "$CONFIG_FILE" > "$temp_file"
        mv "$temp_file" "$CONFIG_FILE"
        echo -e "${GREEN}Updated dates for client '$client_code'${NC}"
    fi
    
    echo "  process_date: $process_date"
    echo "  term_date: $term_date"
}

# List all client codes
list_clients() {
    echo -e "${BLUE}Client Codes:${NC}"
    if ! jq -r '.clients | keys[]' "$CONFIG_FILE" 2>/dev/null | sort; then
        echo -e "${RED}Error: Failed to parse client codes from config file${NC}"
        return 1
    fi
    echo ""
    local total=$(jq -r '.clients | length' "$CONFIG_FILE" 2>/dev/null)
    if [ -n "$total" ]; then
        echo -e "${GREEN}Total clients: $total${NC}"
    else
        echo -e "${RED}Error: Failed to get client count${NC}"
        return 1
    fi
}

# Show configuration for a specific client
show_client() {
    local client_code="$1"
    
    if [ -z "$client_code" ]; then
        echo -e "${RED}Usage: $0 show-client <client_code>${NC}"
        exit 1
    fi
    
    if ! jq -e ".clients.\"$client_code\"" "$CONFIG_FILE" > /dev/null 2>&1; then
        echo -e "${RED}Error: Client '$client_code' does not exist${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Configuration for client '$client_code':${NC}"
    jq ".clients.\"$client_code\"" "$CONFIG_FILE"
}

# Restore from backup
restore_backup() {
    local backup_file="$1"
    
    if [ -z "$backup_file" ]; then
        echo -e "${YELLOW}Available backups:${NC}"
        ls -1t "$BACKUP_DIR"/*.json 2>/dev/null || echo "No backups found"
        echo ""
        echo -e "${RED}Usage: $0 restore <backup_file>${NC}"
        exit 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        # Try looking in backup directory
        if [ -f "$BACKUP_DIR/$backup_file" ]; then
            backup_file="$BACKUP_DIR/$backup_file"
        else
            echo -e "${RED}Error: Backup file not found: $backup_file${NC}"
            exit 1
        fi
    fi
    
    cp "$CONFIG_FILE" "$CONFIG_FILE.before_restore"
    cp "$backup_file" "$CONFIG_FILE"
    echo -e "${GREEN}Restored from: $backup_file${NC}"
    echo -e "${YELLOW}Previous config saved as: $CONFIG_FILE.before_restore${NC}"
}

# Show help
show_help() {
    echo "Batch Eligibility Transfer Config Manager"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  update-field <client|ALL> <path> <value>  Update a field"
    echo "  delete-field <client|ALL> <path>          Delete a field"
    echo "  insert-client <code> [template]           Insert a new client"
    echo "  delete-client <code>                      Delete a client"
    echo "  enable-client <client|ALL>                Enable a client"
    echo "  disable-client <client|ALL>               Disable a client"
    echo "  set-hold <client|ALL>                     Set term_by_exclusion hold flag"
    echo "  clear-hold <client|ALL>                   Clear term_by_exclusion hold flag"
    echo "  update-dates <client|ALL> <proc> [term]   Update dates"
    echo "  list-clients                              List all client codes"
    echo "  show-client <code>                        Show client configuration"
    echo "  backup                                    Create a backup"
    echo "  restore <backup_file>                     Restore from backup"
    echo "  help                                      Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 list-clients"
    echo "  $0 show-client rd"
    echo "  $0 enable-client rd"
    echo "  $0 set-hold ALL"
    echo "  $0 update-dates rd 20251103 20251104"
    echo "  $0 update-field rd term_by_exclusion.max_term_count \\\"0000000001000\\\""
    echo "  $0 backup"
}

# Main script
main() {
    check_jq
    
    # Change to script directory
    cd "$SCRIPT_DIR"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}Error: Config file not found: $CONFIG_FILE${NC}"
        exit 1
    fi
    
    local command="$1"
    shift
    
    case "$command" in
        update-field)
            update_field "$@"
            ;;
        delete-field)
            delete_field "$@"
            ;;
        insert-client)
            insert_client "$@"
            ;;
        delete-client)
            delete_client "$@"
            ;;
        enable-client)
            enable_client "$@"
            ;;
        disable-client)
            disable_client "$@"
            ;;
        set-hold)
            set_hold "$@"
            ;;
        clear-hold)
            clear_hold "$@"
            ;;
        update-dates)
            update_dates "$@"
            ;;
        list-clients)
            list_clients
            ;;
        show-client)
            show_client "$@"
            ;;
        backup)
            backup_config
            ;;
        restore)
            restore_backup "$@"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}Unknown command: $command${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
