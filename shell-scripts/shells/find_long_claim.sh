#!/bin/sh

filename="$1"
CR="
"
OIFS="$IFS"

TMPFILE="/tmp/find_long_claim.$$"

usage()
{
	echo $0 switch_filename
	exit 1
}

if [ "$filename" == "" ]
then
	usage
	exit 1
fi

if [ ! -f "$filename" ]
then
	echo "Could not find file '${filename}'"
	exit 1
fi


cat $filename | grep "^Line" | sort -t= -nrk4


rm -f $TMPFILE
