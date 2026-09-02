#!/bin/sh

# Create the queue
sndmsg 210 "NIL|" 2 5

while [ 1 ]
do
	file=`rcvmsg 210 2|awk -F\| '{ print $1 }'`

	if [ "$file" = "NIL" ]
	then
		continue
	fi
	/usr/lnk/shell/sendmailfile $file
done
