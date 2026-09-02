#!/bin/bash

# Get yesterday's date in the format yyyymmdd
yesterday=$(date -d "yesterday" +"%Y%m%d")

# Base directory
base_dir="/usr/local/logs/linedrv"

# Switch directories
switch_dirs=("switch10" "switch16" "switch40" "switch70" "switch90")

# Temporary directory for output files
output_dir="/tmp"
mkdir -p "$output_dir"

# Variable to check if any output file has records
has_records=false

# Process each switch directory
for switch in "${switch_dirs[@]}"; do
    input_file="${base_dir}/${switch}/${switch}-${yesterday}"

    # Check if the input file exists
    if [ -f "$input_file" ]; then
        output_file="${output_dir}/${switch}-${yesterday}-longrunning.txt"
        /usr/lnk/shell/pull_long_running_claims.sh "$input_file" > "$output_file"
        
        # Check if the output file has any records
        if [ -s "$output_file" ]; then
            has_records=true
        else
            rm "$output_file"  # Remove empty output file
        fi
    else
        echo "File ${input_file} does not exist. Skipping..."
    fi
done

# Only create and send the zip file if any output file has records
if [ "$has_records" = true ]; then
    # Create the zip file
    zip_file="${output_dir}/longrunning-claims-${yesterday}.zip"
    cd "$output_dir" || exit
    zip -r "$zip_file" ./*-${yesterday}-longrunning.txt

    scp "$zip_file" cobol-dev01:/tmp
    ssh cobol-dev01 "chmod 644 $zip_file"

    echo "Long running claim file has been copied to cobol-dev01:$zip_file" | mail -s "Long running claims" TransTeam@pdmi.com

    echo "Processing completed. Output zip file: $zip_file"
else
    echo "No records found in output files. Email not sent."
fi

