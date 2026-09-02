#!/bin/sh


TMPFILE="/tmp/switchfile.tmp.$$"
TMPFILE2="/tmp/switchfile.tmp2.$$"

usage()
{
	echo "usage: $0 switchfile"
	exit 1
}

inputfile="$1"

if [ ! -f "$inputfile" ]
then
	usage
	exit 1
fi



# Remove blank lines and lines starting with "Line"
cat  $inputfile | grep -v "^Line" | sed '/^$/d'  >$TMPFILE


# Get input claim 
awk -F '{ print $1 }' $TMPFILE >$TMPFILE2



cat $TMPFILE2 | cut -c8- >$TMPFILE

cat $TMPFILE



rm -f $TMPFILE $TMPFILE2
