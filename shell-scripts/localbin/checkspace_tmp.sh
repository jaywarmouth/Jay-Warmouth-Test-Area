#!/bin/sh

# Value when notification should be sent.
FLAG_LIMIT="75"

# Value to clear the lockfile
# CLEAR_LIMIT Must be less than FLAG_LIMIT
CLEAR_LIMIT="50"

# Lockfile is used to prevent multiple emails
LOCKFILE="/tmp/.checkspace.prod10.usr-pdm.lock"

MAILTO="operations@pdmi.com OperatorPage@pdmi.com"

pdmsize=`df -l | grep "/dev/sda8" | awk '{ print $5 }'|sed s/\%//g`

if [ "$1" = "-c" ]
then
	echo "Manual clear of lockfile."
	echo "No check performed."
	rm -f $LOCKFILE
	exit 0
fi


if [ "$pdmsize" -ge "$FLAG_LIMIT" -a ! -f "$LOCKFILE" ]
then
	
	echo "Space low, flag set"

	touch $LOCKFILE
	echo "prod10:/tmp is nearing capacity!" | mail -s "Space on prod10:/tmp" $MAILTO
	

fi

if [ "$pdmsize" -le "$CLEAR_LIMIT" -a  -f "$LOCKFILE" ]
then
	echo "Space free, lockfile cleared."
	rm -f $LOCKFILE
	echo "prod10:/tmp free space returning" | mail -s "Space on prod10:/tmp" $MAILTO
fi


