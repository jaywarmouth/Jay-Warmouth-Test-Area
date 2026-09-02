#!/bin/sh

#       Name: check_traffic_restart.sh
#       By  : Steven Randlett
#       Date: 12/2/2011
#       Purpose:
#		Email if traffic program restarts (compu05)
#
#  		Creates the file /home/srandlet/pub/check_traffic_restart.page
#
#


do_mail()
{
filename="$1"

#for sendto in `echo $MAILUSER`
#do
MAILFILE="/tmp/mailfile.tmp.$$"

	echo "Claims processing traffic has restarted" >$MAILFILE
	echo "Log files are located on cobol-dev01:${filename}" >>$MAILFILE
	echo " " >>$MAILFILE
	echo "Restart log: " >>$MAILFILE
	cat $TMP_DIFF_FILE >>$MAILFILE

	cat $MAILFILE | /bin/mail -s "Traffic resubmitted" $MAILUSER

	rm -f $MAILFILE
#done


}

generate_logs()
{
OUTZIPFILE="$1"

/usr/local/bin/generate_trafficlogs.sh "$OUTZIPFILE"


}

#MAILUSER="operations@pdmi.com"
MAILUSER="TransTeam@pdmi.com operations@pdmi.com"
#MAILUSER="srandlet@pdmi.com"

#DIFF_FILE="/tmp/check_traffic_restart.diff.test"
DIFF_FILE="/usr/local/etc/check_traffic_restart.diff"
TRAFFIC_LOG="/usr/lnk/traflog/traffic02.restart.log"
TMP_DIFF_FILE="/tmp/.check_traffic_restart.tmp"

# MAIN

trap 'rm -f $TMP_DIFF_FILE' 0

server=`echo "$HOSTNAME" | awk -F. '{ print $1 }'`

if [ "$server" != "prod10" ]
then
	echo "Aborting.  Not on prod10"
	exit 0
fi

TDATE=`/bin/date +%Y%m%d`
TTIME=`/bin/date +%H%M`
OUTZIPFILE="/tmp/traffic_logs_${TDATE}_${TTIME}.zip" 

if [ ! -f "$TRAFFIC_LOG" ]
then
	echo "No log exists.  $TRAFFIC_LOG"
	exit 0
fi

cp $TRAFFIC_LOG $TMP_DIFF_FILE
diff $TMP_DIFF_FILE $DIFF_FILE >/dev/null
result="$?"

if [ "$result" -ne "0" ] 
then
	echo "Traffic log changed.  Sending notification."
	cp $TMP_DIFF_FILE $DIFF_FILE
	generate_logs "$OUTZIPFILE"
#	/usr/bin/scp $OUTZIPFILE cobol-dev01:/tmp
       rsync -avz --chmod=644 "$OUTZIPFILE" cobol-dev01:/tmp
	do_mail	"$OUTZIPFILE"
fi

exit 0
