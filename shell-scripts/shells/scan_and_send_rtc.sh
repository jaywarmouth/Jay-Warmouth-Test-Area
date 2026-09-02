#!/bin/sh

## Shell to look for RTC JSON files and send them to MIRTH

usage(){
echo "scan_and_send_rtc.sh path"
echo "path - path to RTC files to send"
exit 1
}

SEND_SCRIPT="/usr/lnk/shell/postfile.sh"
SEND_URL="http://mirth-prod.pdmi.com:8885/rtc/"
MAX_THREADS="10"

# Hold old the file must be (in seconds) before it can be sent
DELAY_TIME="3"

# Age of file in seconds to remove if still zero bytes long
REMOVE_TIME="30"

scandir="$1"

if [ "$scandir" == "" ]
then
	usage
exit 1
fi

while [ 1 ]
do

	found_file="0"

	for file in `ls -rt "$scandir"  | head -${MAX_THREADS}`
	do
		CurrentTime=`date +%s`
		found_file="1"

		PathAndFile="${scandir}/${file}"
		filetime=`stat -c %Y $PathAndFile`
		echo $PathAndFile $filetime
		timediff=`expr $CurrentTime - $filetime`

		if [ "$timediff" -ge "$REMOVE_TIME" -a ! -s "$PathAndFile" ]
		then
			echo "Removing $PathAndFile.  Zero byte file older than $REMOVE_TIME seconds"
			rm -f $PathAndFile
		fi

		if [ "$timediff" -ge "$DELAY_TIME" -a -s "$PathAndFile" ]
		then
			echo "Processing $PathAndFile"
			$SEND_SCRIPT $SEND_URL $PathAndFile &	
		else
			echo "To young:  $PathAndFile"
		fi
	

	done
	wait

	if [ "$found_file" -eq "0" ]
	then
		sleep 5
	else
		sleep 1
	fi

done
