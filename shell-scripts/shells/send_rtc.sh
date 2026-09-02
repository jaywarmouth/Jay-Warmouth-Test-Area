#!/bin/sh

# This shell is designed to send a real-time claim file to the production 
# queue.  Use with caution!

RTC_QUEUE="67"


usage() 
{
	echo "USAGE: send_rtc.sh filename"
}


filename="$1"

if [ ! -f "$filename" ]
then
	usage
	exit 1
fi

if [[ ! "$filename" = /* ]]
	then
	echo "Error: Filename must contain an absolute path."
	usage
	exit 1
fi

outstring="$filename|1\0"

echo -e "$outstring" | sndmsg $RTC_QUEUE stdin 2 ${#outstring}

