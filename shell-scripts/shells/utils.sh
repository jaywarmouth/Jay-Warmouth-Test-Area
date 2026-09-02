#!/bin/bash
#
# Simple Utilities for Report Transfer
#

SCRIPT_DIR="$(dirname "$0")"
CONFIG_FILE="$SCRIPT_DIR/config/transfer_config.json"

# Test if client works
test_client() {
    local client="${1:-$CLIENT}"
    if [[ -z "$client" ]]; then
        echo "Usage: test_client <CLIENT_NAME>"
        return 1
    fi
    
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "❌ Config file not found"
        return 1
    fi
    
    if ! jq -e ".clients.\"$client\"" "$CONFIG_FILE" >/dev/null 2>&1; then
        echo "❌ Client $client not found"
        return 1
    fi
    
    local enabled=$(jq -r ".clients.\"$client\".enabled // false" "$CONFIG_FILE")
    if [[ "$enabled" != "true" ]]; then
        echo "❌ Client $client is disabled"
        return 1
    fi
    
    local s3_enabled=$(jq -r ".clients.\"$client\".destinations.aws_s3.enabled // false" "$CONFIG_FILE")
    if [[ "$s3_enabled" != "true" ]]; then
        echo "❌ S3 not enabled for $client"
        return 1
    fi
    
    echo "✅ Client $client is ready"
    echo "   S3 Bucket: $(jq -r ".clients.\"$client\".destinations.aws_s3.bucket_name" "$CONFIG_FILE")"
    echo "   Formats:"
    
    # Show formats
    local print29_formats=$(jq -r ".clients.\"$client\".destinations.aws_s3.formats.PRINT29[]?" "$CONFIG_FILE" 2>/dev/null)
    local ca29_formats=$(jq -r ".clients.\"$client\".destinations.aws_s3.formats.CA29[]?" "$CONFIG_FILE" 2>/dev/null)
    local default_formats=$(jq -r ".clients.\"$client\".destinations.aws_s3.formats.default[]?" "$CONFIG_FILE" 2>/dev/null)
    
    if [[ -n "$print29_formats" ]]; then
        echo "     PRINT29: $print29_formats"
    fi
    if [[ -n "$ca29_formats" ]]; then
        echo "     CA29: $ca29_formats"
    fi
    if [[ -n "$default_formats" ]]; then
        echo "     Default: $default_formats"
    fi
}

# List all clients
list_clients() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "❌ Config file not found"
        return 1
    fi
    
    echo "Configured clients:"
    jq -r '.clients | keys[]' "$CONFIG_FILE" | while read -r client; do
        local enabled=$(jq -r ".clients.\"$client\".enabled // false" "$CONFIG_FILE")
        local status="✅"
        [[ "$enabled" != "true" ]] && status="❌"
        echo "  $status $client"
    done
}

# Show config for client
show_config() {
    local client="${1:-$CLIENT}"
    if [[ -z "$client" ]]; then
        echo "Usage: show_config <CLIENT_NAME>"
        return 1
    fi
    
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "❌ Config file not found"
        return 1
    fi
    
    jq ".clients.\"$client\"" "$CONFIG_FILE" 2>/dev/null || echo "❌ Client $client not found"
}

# Basic validation
validate_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "❌ Config file not found: $CONFIG_FILE"
        return 1
    fi
    
    if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
        echo "❌ Invalid JSON in config file"
        return 1
    fi
    
    echo "✅ Config file is valid JSON"
    echo "✅ Found $(jq -r '.clients | keys | length' "$CONFIG_FILE") clients"
}

# Show usage
usage() {
    echo "Simple Report Transfer Utilities"
    echo ""
    echo "Commands:"
    echo "  test_client <CLIENT>   - Test if client is configured correctly"
    echo "  list_clients          - List all configured clients"
    echo "  show_config <CLIENT>  - Show configuration for client"
    echo "  validate_config       - Validate configuration file"
    echo ""
    echo "Environment variables:"
    echo "  CLIENT - Default client name"
}

# Main command handler
case "${1:-}" in
    "test"|"test_client") test_client "$2" ;;
    "list"|"list_clients") list_clients ;;
    "show"|"show_config") show_config "$2" ;;
    "validate"|"validate_config") validate_config ;;
    "help"|"--help"|"-h"|"") usage ;;
    *) echo "Unknown command: $1"; usage; exit 1 ;;
esac