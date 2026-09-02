#!/bin/bash
#
# Example integration for CARDH29 report generation script
# Shows how to pass CA29 and PRINT29 files with absolute paths
#

# ... your existing report generation logic above ...

# After generating PRINT29 and CA29 reports, you will have the file paths:
# NOTE: Both files are ALWAYS in .txt format
PRINT29_REPORT="/usr/lnk/elig_out/sys0218/20251007-124116-PRINT-29-eme1006.txt"
CA29_REPORT="/usr/lnk/elig_out/sys0218/20251007-124116-CA29-eme1006.txt"

# =============================================================================
# Multi-Report Transfer Integration - Using Direct File Paths
# =============================================================================

echo "Starting report transfer..."

# Set environment variables with direct file paths
export CLIENT="em"                        # Client identifier
export SYS="0218"                         # System identifier
export PRINT29_FILE="${PRINT29_REPORT}"  # Absolute path to PRINT29 file
export CA29_FILE="${CA29_REPORT}"        # Absolute path to CA29 file

# Path to transfer system
TRANSFER_SYSTEM_PATH=$(pwd)

# Call the transfer system
if [[ -f "$TRANSFER_SYSTEM_PATH/multi_report_transfer.sh" ]]; then
    "$TRANSFER_SYSTEM_PATH/multi_report_transfer.sh"
    if [[ $? -eq 0 ]]; then
        echo "Transfer completed successfully"
    else
        echo "Transfer failed"
        exit 1
    fi
else
    echo "Transfer system not found at: $TRANSFER_SYSTEM_PATH"
    exit 1
fi

# ... rest of your report generation script ...

# =============================================================================
# Alternative: Transfer only one type of report
# =============================================================================

# Transfer only PRINT29:
# export CLIENT="LINET001"
# export SYS="01"
# export PRINT29_FILE="/path/to/PRINT29_file.txt"
# unset CA29_FILE
# ./multi_report_transfer.sh

# Transfer only CA29:
# export CLIENT="LINET001"
# export SYS="01"
# export CA29_FILE="/path/to/CA29_file.txt"
# unset PRINT29_FILE
# ./multi_report_transfer.sh

# =============================================================================
# Note: PDF Conversion
# =============================================================================
# - CA29 and PRINT29 files are ALWAYS provided in .txt format
# - If your config specifies "pdf" format, the script will automatically
#   convert .txt files to .pdf before uploading to S3
# - You can configure both "txt" and "pdf" formats to upload both versions
