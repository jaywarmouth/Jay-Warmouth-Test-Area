#!/bin/bash

TMPFILE="/tmp/.get_process_swap.tmp.$$"

echo -e "COMMAND|PID|SWAP USAGE|SWAP UNIT SIZE" >$TMPFILE
for file in /proc/*/status 
do 
#	echo $file
	if [ -f $file ]
	then
		awk '/VmSwap|Name|^Pid/{printf $2 "|" $3}END{ print ""}' $file 
	fi
done  |  sort -k 3 -t \| -n -r >>$TMPFILE

cat $TMPFILE  | column -t -s\|
rm -f $TMPFILE
exit 0
