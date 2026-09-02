#!/bin/bash

# Check if a filename is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

filename=$1

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File not found!"
    exit 1
fi

declare -A previous_runtimes

# Read the file line by line
while IFS= read -r line
do
    if [[ $line == Line=* ]]; then
        # Extract Q= and Runtime value using regex
        if [[ $line =~ Q=([0-9]+) ]]; then
            queue=${BASH_REMATCH[1]}
        fi
        if [[ $line =~ Runtime=([0-9]+) ]]; then
            runtime=${BASH_REMATCH[1]}
        fi
        
        # Read the next line (data line)
        read -r data
        # Read the blank line
        read -r blank
        
        # Check if this transaction's Runtime > 10000 and the previous was < 5000
        if (( runtime > 10000 )) && [[ -n ${previous_runtimes[$queue]} ]] && (( previous_runtimes[$queue] < 5000 )); then
            echo "$line"
            echo "$data"
            echo "$blank"
        fi
        
        # Update the previous runtime for this queue
        previous_runtimes[$queue]=$runtime
    fi
done < "$filename"

