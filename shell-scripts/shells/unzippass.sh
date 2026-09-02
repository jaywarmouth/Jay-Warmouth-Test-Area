#!/bin/sh

usage()
{
	echo "USAGE:"
	echo "unzippass.sh zipfile destdir filename"
}

if [ $# -lt 3 ]
then
	usage
	exit 1
fi
ZIPFILE=$1
DEST=$2
FILE=$3

UNZIP="/usr/bin/unzip"
PASSWORDFILE="/usr/local/pub/zippass.txt"

PASS=`cat $PASSWORDFILE | grep -v "^#"`

unzip -P $PASS -d $DEST $ZIPFILE $FILE
RETVAL=$?

exit $RETVAL
