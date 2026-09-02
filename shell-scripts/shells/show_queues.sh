#!/bin/sh

OIFS="$IFS"
CR="
"

TMPFILE="/tmp/.show_queue.sh.$$"

trap 'rm -f $TMPFILE' 0


rm -f $TMPFILE
touch $TMPFILE

IFS="$CR"
for line in `/usr/bin/ipcs -q | tail -n+4` 
do
	IFS="$OIFS"

okey="`echo $line | awk '{ print $1 }'`"
key=${okey:2}
key="$((16#${key}))"
key=`printf "%08d" $key`

#echo $key

echo "$key $line" >>$TMPFILE
	IFS="$CR"
done

echo -e "\n------ Message Queues --------"

echo "key(dec) `/usr/bin/ipcs -q | tail -n+3|head -n 1`"

cat $TMPFILE | sort -n

exit 0

