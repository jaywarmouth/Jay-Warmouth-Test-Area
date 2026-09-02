#!/bin/sh

#       Name: generate_trafficlogs.sh
#       By  : Steven Randlett
#       Purpose:
#		Generate traffic log zip file for copy to dev system for cobol team
#


generate_logs()
{

OUTZIPFILE="$1"

cd /usr/local/logs/linedrv
echo 'grep -a "Generating" * | sort -t: -k 2' > switch16/find_errors.sh
chmod 755 switch16/find_errors.sh
cp switch16/find_errors.sh switch40/find_errors.sh
chmod 755 switch40/find_errors.sh

/usr/bin/zip -9 -q  $OUTZIPFILE  switch10/find* switch10/switch10.lineinfo switch10/tcp* switch16/find* switch16/switch16.lineinfo switch16/tcp* switch40/find* switch40/switch40.lineinfo switch40/tcp*  switch70/find* switch70/switch70.lineinfo switch70/tcp*  switch90/find* switch90/switch90.lineinfo switch90/tcp*


}


# MAIN

filename="$1"
if [ "$filename" == "" ]
then
	TDATE=`/bin/date +%Y%m%d`
	TTIME=`/bin/date +%H%M`
	filename="/tmp/traffic_logs_${TDATE}_${TTIME}.zip" 
else
	filename="$filename"
fi

	generate_logs "$filename"
#echo	/usr/bin/scp "$filename" cobol-dev01:/tmp

exit 0
