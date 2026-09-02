#!/bin/sh

#
#
#

send_page() {
switchname="$1"
message="$2"
	echo "${switchname}:$message" | /usr/bin/mutt -s "claim watcher - $switchname" $MAILTO
}


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


MAILTO="srandlet@pdmi.com"

switchdir="/usr/lnk/daily"
#switchdir="/tmp"
switchdate=`/bin/date "+%Y%m%d"`
LOGFILE="/tmp/.claim_watcher.${switchname}.lastrun.log"
DATFILE="/usr/local/pub/claim_watcher.${switchname}.lastrun.dat"
pagefile="/tmp/.claim_watcher.${switchname}.claim_watcher.sent"

switchfile="${switchdir}/${switchname}/${switchname}-$switchdate"


if [ ! -f "$switchfile" ]
then
	echo "Switch file \"$switchfile\" does not exist" >>$LOGFILE
	exit 1
fi

lastdate="none"

if [ -f "$DATFILE" ]
then
	lastdate=`cat $DATFILE`
fi

filedate="`/usr/bin/stat -c %y $switchfile | cut -c 1-19`"

got_transaction="0"

if [ "$filedate" == "$lastdate" ]
then
	touch $pagefile
	send_page $switchname " warning: Transaction not received since $lastdate"

else
	if [ -f "$pagefile" ]
	then
		rm -f $pagefile
		send_page $switchname " cleared:  Claim received at $filedate"
	fi
fi



echo $filedate >$DATFILE
exit 0

