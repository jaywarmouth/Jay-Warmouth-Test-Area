#!/bin/bash
# Load COBOL binary file into MySQL
# Usage: ./load_cobol_file.sh <layout_name> <binary_file> <operation>
#   layout_name: e.g., cardh00mas (without _layout.json)
#   binary_file: path to COBOL binary file
#   operation: I (INSERT), U (UPDATE), or D (DELETE)

if [ $# -ne 3 ]; then
    echo "Usage: $0 <layout_name> <binary_file> <operation>"
    echo "  layout_name: e.g., cardh00mas"
    echo "  binary_file: path to COBOL binary file"
    echo "  operation: I (INSERT), U (UPDATE), or D (DELETE)"
    exit 1
fi

LAYOUT_NAME=$1
BINARY_FILE=$2
OPERATION=$3

# Validate operation
if [[ ! "$OPERATION" =~ ^[IUD]$ ]]; then
    echo "ERROR: Operation must be I, U, or D"
    exit 1
fi

# Set paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAYOUT_FILE="$SCRIPT_DIR/../../layouts/${LAYOUT_NAME}_layout.json"
TEMP_CSV="$BINARY_FILE.csv"

# Check if layout exists
if [ ! -f "$LAYOUT_FILE" ]; then
    echo "ERROR: Layout file not found: $LAYOUT_FILE"
    exit 1
fi

# Check if binary file exists
if [ ! -f "$BINARY_FILE" ]; then
    echo "ERROR: Binary file not found: $BINARY_FILE"
    exit 1
fi

echo "============================================"
echo "COBOL to MySQL Loader"
echo "============================================"
echo "Layout:     $LAYOUT_NAME"
echo "Binary:     $BINARY_FILE"
echo "Operation:  $OPERATION"
echo "============================================"

# Step 1: Convert binary to CSV
echo ""
echo "Step 1: Converting COBOL binary to CSV..."
python3 "$SCRIPT_DIR/../utils/binary_to_csv.py" "$LAYOUT_FILE" "$BINARY_FILE" "$TEMP_CSV"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to convert binary to CSV"
    exit 1
fi

# Count records
RECORD_COUNT=$(($(wc -l < "$TEMP_CSV") - 1))
echo "✓ Converted: $RECORD_COUNT record(s)"

# Step 2: Load to MySQL
echo ""
echo "Step 2: Loading to MySQL..."
python3 "$SCRIPT_DIR/../utils/csv_to_mysql.py" "$LAYOUT_FILE" "$TEMP_CSV" "$OPERATION"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to load to MySQL"
    exit 1
fi

# Cleanup
echo ""
echo "Step 3: Cleanup..."
rm -f "$TEMP_CSV"
echo "✓ Removed temporary CSV file"

echo ""
echo "============================================"
echo "COMPLETE"
echo "============================================"
