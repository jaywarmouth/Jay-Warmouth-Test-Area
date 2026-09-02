#!/bin/bash
#
# Simple Integration Wrapper
# Call this script from your report generation process
#
# Usage:
#     export CLIENT=LINET001 SYS=01
#     export PRINT29_FILE=/absolute/path/to/PRINT29_file.txt
#     export CA29_FILE=/absolute/path/to/CA29_file.txt
#     /usr/lnk/shell/multi_report_integration.sh
#
# Notes:
# - Files must be provided as absolute paths
# - CA29 and PRINT29 files are always in .txt format
# - PDF conversion happens automatically if configured
#

# Required environment variables
CLIENT="${CLIENT}"
SYS="${SYS}"
PRINT29_FILE="${PRINT29_FILE}"
CA29_FILE="${CA29_FILE}"

# Script location
SCRIPT_DIR="/usr/lnk/shell"

# Execute the transfer script
exec "$SCRIPT_DIR/multi_report_transfer.sh"

