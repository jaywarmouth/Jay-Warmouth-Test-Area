#!/bin/sh

## Shell to look for RTC JSON files and send them to MIRTH

usage(){
echo "post_claim_metadata.sh path"
echo "path - path to files to send"
exit 1
}

SEND_SCRIPT="/usr/lnk/shell/postfile.sh"
SEND_URL="http://mirth-prod.pdmi.com:8886/claimmeta/"
MAX_THREADS="250"
DELAY_TIME="2"

# Set ArchivePath = "" for no archive
ArchivePath=""

scandir="$1"

if [ "$scandir" == "" ]
then
	usage
exit 1
fi

while [ 1 ]
do

	echo "checking"
	found_file="0"

	for file in `ls -f "$scandir"  | head -${MAX_THREADS}`
	do
		CurrentTime=`date +%s`
		found_file="1"

		PathAndFile="${scandir}/${file}"
		filetime=`stat -c %Y $PathAndFile`
		echo $PathAndFile $filetime
		timediff=`expr $CurrentTime - $filetime`
		if [ "$timediff" -ge "$DELAY_TIME" ]
		then
			echo "Processing $PathAndFile"
			$SEND_SCRIPT $SEND_URL $PathAndFile $ArchivePath &	
		else
			echo "To young:  $PathAndFile"
		fi
	

	done
	wait

	if [ "$found_file" -eq "0" ]
	then
		echo "sleeping"
		sleep 5
	else
		sleep 1
	fi

done
