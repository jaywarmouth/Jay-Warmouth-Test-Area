#!/bin/sh

# code will remove PDMI segment from a raw claim.

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file="$1"


perl -pe 's/\x1E\x1CAMPD.*?(\x1E|\x03|$)//g' $file
