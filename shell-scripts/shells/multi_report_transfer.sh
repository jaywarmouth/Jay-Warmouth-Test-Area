#!/bin/bash
#
# Simple Report Transfer to S3
# Transfers PRINT29 and CA29 reports to AWS S3
#
# Features:
# - Supports multiple file formats (txt, pdf)
# - Automatic PDF conversion from txt files when pdf format is configured
# - Client-based configuration with format specifications
# - Centralized logging with date-based rotation
#
# Usage:
#     export CLIENT=LINET001 SYS=01
#     export PRINT29_FILE=/absolute/path/to/PRINT29_file.txt
#     export CA29_FILE=/absolute/path/to/CA29_file.txt
#     ./multi_report_transfer.sh
#
# Environment Detection:
# - CONFIG is automatically determined from hostname
# - If hostname contains "prod10": uses batch_elig_transfer_config.json
# - Otherwise: uses batch_elig_transfer_config_oth.json
#
# Notes:
# - CA29 and PRINT29 files are always provided in .txt format
# - If config specifies pdf format, files will be automatically converted
# - Requires enscript and ps2pdf for PDF conversion
#

# Required environment variables:
CLIENT=${CLIENT}
SYS=${SYS}
PRINT29_FILE=${PRINT29_FILE}
CA29_FILE=${CA29_FILE}

# AWS CLI path
AWS_CLI="/usr/local/bin/aws"

# Determine CONFIG based on hostname
HOSTNAME=$(hostname)
if [[ "$HOSTNAME" == "prod10.pdmboardman.local" ]]; then
    CONFIG="prod10"
else
    CONFIG="other"
fi

# Determine config file based on CONFIG variable
if [[ "$CONFIG" == "prod10" ]]; then
    CONFIG_NAME="batch_elig_transfer_config.json"
else
    CONFIG_NAME="batch_elig_transfer_config_oth.json"
fi

CONFIG_FILE="/usr/lnk/obj/config/$CONFIG_NAME"
LOG_DIR="/usr/lnk/audit/batch_elig"
mkdir -p "$LOG_DIR"

# Get current date for log filename
CURRENT_DATE=$(date '+%Y%m%d')

# Simple logging
log() {
    echo "$(date '+%H:%M:%S') $1" >> "$LOG_DIR/transfer_$CURRENT_DATE.log"
}

# Convert text file to PDF
# Usage: convert_to_pdf <input_txt_file> <output_pdf_file>
convert_to_pdf() {
    local INPUT_FILE="$1"
    local OUTPUT_FILE="$2"
    
    # Convert txt -> ps -> pdf
    local TEMP_PS="${OUTPUT_FILE}.ps"
    
    if enscript -B -f Courier10 -o "$TEMP_PS" "$INPUT_FILE" 2>/dev/null && \
       ps2pdf "$TEMP_PS" "$OUTPUT_FILE" 2>/dev/null; then
        rm -f "$TEMP_PS"
        return 0
    else
        rm -f "$TEMP_PS"
        log "ERROR: Failed to convert $INPUT_FILE to PDF"
        return 1
    fi
}

# Check minimum required variables
if [[ -z "$CLIENT" || -z "$SYS" ]]; then
    log "ERROR: Missing required variables (CLIENT, SYS)"
    exit 1
fi

# Check if at least one file is provided
if [[ -z "$PRINT29_FILE" && -z "$CA29_FILE" ]]; then
    log "ERROR: At least one file required (PRINT29_FILE or CA29_FILE)"
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    log "ERROR: Config file not found: $CONFIG_FILE"
    exit 1
fi

# Check if client exists and is enabled
if ! jq -e ".clients.\"$CLIENT\"" "$CONFIG_FILE" >/dev/null 2>&1; then
    log "INFO: Client $CLIENT not configured - exiting"
    exit 0
fi

ENABLED=$(jq -r ".clients.\"$CLIENT\".enabled // false" "$CONFIG_FILE")
if [[ "$ENABLED" != "true" ]]; then
    log "INFO: Client $CLIENT disabled - exiting"
    exit 0
fi

# Check if cardh29_reports is enabled
CARDH29_ENABLED=$(jq -r ".clients.\"$CLIENT\".cardh29_reports.enabled // false" "$CONFIG_FILE")
if [[ "$CARDH29_ENABLED" != "true" ]]; then
    log "INFO: cardh29_reports disabled for client $CLIENT - exiting"
    exit 0
fi

log "Starting transfer for $CLIENT"

# Find files to transfer
FILES=()

if [[ -n "$PRINT29_FILE" ]]; then
    if [[ -f "$PRINT29_FILE" ]]; then
        FILES+=("$PRINT29_FILE")
        log "Added PRINT29 file: $PRINT29_FILE"
    else
        log "WARNING: PRINT29_FILE not found: $PRINT29_FILE"
    fi
fi

if [[ -n "$CA29_FILE" ]]; then
    if [[ -f "$CA29_FILE" ]]; then
        FILES+=("$CA29_FILE")
        log "Added CA29 file: $CA29_FILE"
    else
        log "WARNING: CA29_FILE not found: $CA29_FILE"
    fi
fi

if [[ ${#FILES[@]} -eq 0 ]]; then
    log "No files found to transfer"
    exit 0
fi

log "Found ${#FILES[@]} files to transfer"

# Get S3 settings from cardh29_reports section
BUCKET=$(jq -r ".clients.\"$CLIENT\".cardh29_reports.aws_s3.bucket_name" "$CONFIG_FILE")
PREFIX_TEMPLATE=$(jq -r ".clients.\"$CLIENT\".cardh29_reports.aws_s3.prefix // \"reports/{client}/\"" "$CONFIG_FILE")

# Build S3 prefix
PREFIX="${PREFIX_TEMPLATE//\{client\}/$CLIENT}"

log "Uploading to s3://$BUCKET/$PREFIX"

# Transfer each file
for FILE in "${FILES[@]}"; do
    FILENAME=$(basename "$FILE")
    EXTENSION="${FILENAME##*.}"
    
    # Get report type from filename
    if [[ "$FILENAME" == *PRINT*29* ]]; then
        REPORT="PRINT29"
    elif [[ "$FILENAME" == *CA29* ]]; then
        REPORT="CA29"
    else
        log "WARNING: Unknown report type for $FILENAME - skipping"
        continue
    fi
    
    # Check if format is allowed
    FORMATS=$(jq -r ".clients.\"$CLIENT\".cardh29_reports.aws_s3.formats.\"$REPORT\"[]?" "$CONFIG_FILE" 2>/dev/null)
    
    # Files to upload (may be original or converted)
    UPLOAD_FILES=()
    
    # Check each configured format
    while read -r FORMAT; do
        if [[ -z "$FORMAT" ]]; then
            continue
        fi
        
        # Validate format is only pdf or txt
        if [[ "$FORMAT" != "txt" && "$FORMAT" != "pdf" ]]; then
            log "ERROR: Invalid format '$FORMAT' for $REPORT - only 'txt' and 'pdf' are supported"
            exit 1
        fi
        
        if [[ "$FORMAT" == "txt" && "$EXTENSION" == "txt" ]]; then
            # Upload original txt file
            UPLOAD_FILES+=("$FILE")
        elif [[ "$FORMAT" == "pdf" && "$EXTENSION" == "txt" ]]; then
            # Convert txt to pdf
            PDF_FILE="${FILE%.txt}.pdf"
            log "Converting $FILENAME to PDF..."
            
            if convert_to_pdf "$FILE" "$PDF_FILE"; then
                log "Converted to $(basename "$PDF_FILE")"
                UPLOAD_FILES+=("$PDF_FILE")
            else
                log "❌ Failed to convert $FILENAME to PDF"
                exit 1
            fi
        elif [[ "$FORMAT" == "$EXTENSION" ]]; then
            # Format matches extension, upload as-is
            UPLOAD_FILES+=("$FILE")
        fi
    done <<< "$FORMATS"
    
    # If no formats configured for this report type, skip it
    if [[ ${#UPLOAD_FILES[@]} -eq 0 ]]; then
        log "WARNING: No formats configured for $REPORT - skipping $FILENAME"
        continue
    fi
    
    # Upload all generated files
    for UPLOAD_FILE in "${UPLOAD_FILES[@]}"; do
        UPLOAD_FILENAME=$(basename "$UPLOAD_FILE")
        S3_KEY="${PREFIX}${UPLOAD_FILENAME}"
        log "Uploading $UPLOAD_FILENAME"
        
        if $AWS_CLI s3 cp "$UPLOAD_FILE" "s3://$BUCKET/$S3_KEY" >/dev/null 2>&1; then
            log "✅ Uploaded $UPLOAD_FILENAME"
            
            # Clean up converted PDF files
            if [[ "$UPLOAD_FILE" != "$FILE" && "$UPLOAD_FILE" == *.pdf ]]; then
                rm -f "$UPLOAD_FILE"
            fi
        else
            log "❌ Failed to upload $UPLOAD_FILENAME"
            # Clean up on failure
            if [[ "$UPLOAD_FILE" != "$FILE" && "$UPLOAD_FILE" == *.pdf ]]; then
                rm -f "$UPLOAD_FILE"
            fi
            exit 1
        fi
    done
done

log "Transfer completed successfully"