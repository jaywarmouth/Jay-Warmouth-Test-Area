#!/bin/bash

# Check if the filename is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
  echo "File not found: $1"
  exit 1
fi

filename="$1"
queue=68
etx=$(echo -e "\x03")

# Loop through the file
while IFS= read -r line; do
	message="Z${line}${etx}"
	echo "$message" | sndmsg $queue stdin 2 "${#message}"

	sleep 0.5

done < "$filename"

