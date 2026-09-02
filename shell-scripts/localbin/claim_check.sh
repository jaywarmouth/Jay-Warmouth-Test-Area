#!/bin/sh

# Author: Steve Randlett
# Date 2/3/2018
# Purpose: Indicate if claims have not been received for a period of time.
# WUG Integration


usage() {
echo "claim_watcher switch"
echo "switch=switch16|switch40"
exit 1
}

CR="
"
OIFS="$IFS"

switchname="$1"


if [ "$switchname" = "" ]
then
        usage
        exit 1
fi



switchdir="/usr/local/logs/linedrv"
#switchdir="/tmp"
switchdate=`/bin/date "+%Y%m%d"`
#LOGFILE="/tmp/.claim_watcher.${switchname}.lastrun.log"
DATFILE="/usr/local/pub/claim_watcher.${switchname}.lastrun.dat"
pagefile="/tmp/.claim_watcher.${switchname}.claim_watcher.sent"

switchfile="${switchdir}/${switchname}/${switchname}-$switchdate"

log_date=`date "+%x %r"`


if [ ! -f "$switchfile" ]
then
	echo "Switch file \"$switchfile\" does not exist" 
	echo "$log_date $switchname: switch file \"$switchfile\" does not exist" | /usr/local/bin/logpipe -d -p /tmp/.claim_check 2>&1

	exit 1
fi

lastdate="none"

if [ -f "$DATFILE" ]
then
	lastdate=`cat $DATFILE`
fi
filedate="`/usr/bin/stat -c %y $switchfile | cut -c 1-19`"

got_transaction="0"

if [ "$filedate" != "$lastdate" ]
then
	echo "UP"
	echo "$log_date $switchname Status: UP  Current file date: $filedate Last File Date: $lastdate" | /usr/local/bin/logpipe -d -p /tmp/.claim_check 2>&1

else
	echo "DOWN"

	echo "$log_date $switchname Status: DOWN  Current file date: $filedate Last File Date: $lastdate" | /usr/local/bin/logpipe -d -p /tmp/.claim_check 2>&1

fi



echo $filedate >$DATFILE
exit 0

