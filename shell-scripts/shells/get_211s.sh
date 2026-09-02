#!/bin/bash

# Get the current date in yyyymmdd format
current_date=$(date +%Y%m%d)

# Set the input file path and name
input_file="/usr/lnk/rsp/resp-0000-${current_date}"

# Check if the input file exists
if [ ! -f $input_file ]; then
    echo "File not found"
    exit 1
fi

# Filter records containing " 211 " and print all fields
awk '/ 211 / {print}' $input_file

