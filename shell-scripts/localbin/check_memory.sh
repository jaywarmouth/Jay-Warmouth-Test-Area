#!/bin/sh


# Threshold in KB.

THRESHOLD_KB="2048576"
#THRESHOLD_KB="1048576"
#THRESHOLD_KB="108576"

OIFS="$IFS"
CR="
"

IFS="$CR"

TMPFILE="/tmp/.memory_check.dat"

FOUND=0;

for line in `ps -eo rss,vsz,pid,command | sort -nr`
do
	size=`echo $line | awk '{ print $1 }'`	
	if [ "$size" -gt "$THRESHOLD_KB" ]
	then
		echo $line >>$TMPFILE
		FOUND="1"
	else
		break
	fi
done

if [ "$FOUND" -eq "1" ]
then
	echo "Memory hogs found"
	cat $TMPFILE | mutt -s "PROD10 Memory Hogs"  srandlett@pdmi.com
else
	echo "No memory hogs"
fi

rm -f $TMPFILE

exit 0

	
