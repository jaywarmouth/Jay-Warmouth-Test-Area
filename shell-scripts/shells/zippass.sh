#!/bin/sh

usage()
{
	echo "zippass.sh [zip options]"
	echo "zippass will automatically encrypt the zip file with the system password"
	exit 1
}

ZIP="/usr/bin/zip"
PASSWORDFILE="/usr/local/pub/zippass.txt"

PASS=`cat $PASSWORDFILE | grep -v "^#"`

ZIPOPT="-P $PASS  $ZIPOPT"
export ZIPOPT

ZIPINPUTOPS="$*"


$ZIP $ZIPINPUTOPS
RETVAL="$?"

exit $RETVAL
