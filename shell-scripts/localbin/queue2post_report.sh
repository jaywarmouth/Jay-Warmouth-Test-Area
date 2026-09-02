#!/bin/sh

#       Name: queue2post_report.sh
#       By  : Steven Randlett
#       Date: 11/18/2016
#       Purpose:
#
#	Sends a daily report of any transactions that have not sent.
#
#


usage()
{
	echo "queue2post_report.sh [-e]" 
	echo "-e - send email"
	exit 1
}

do_mail()
{
subject="$1"
file="$2"


for sendto in `echo $MAILUSER`
do
	cat $file | /bin/mail -s "$subject" $sendto 
done


}


####
#
# MAIN
#
####

SEND_EMAIL="0"
RECORDS_FOUND="0"
REPORT_DATE=`date`


if [ "$#" -gt "1" ]
then
	usage
	exit 1
fi

if [ "$#" -eq "1" ]
then

	if [ "$1" = "-e" ] 
	then
		SEND_EMAIL="1"
	else
		usage
	fi
fi



MAILUSER="srandlet@pdmi.com"
config_file_list="APP101P1:/usr/local/etc/rtc/queue2post_app101p1.cfg APP101P2:/usr/local/etc/rtc/queue2post_app101p2.cfg app101p3:/usr/local/etc/rtc/queue2post_app101p3.cfg app201p1:/usr/local/etc/rtc/queue2post_app201p1.cfg app201p2:/usr/local/etc/rtc/queue2post_app201p2.cfg app201p3:/usr/local/etc/rtc/queue2post_app201p3.cfg"

REPORT_FILE="/tmp/.queue2post_report.$$"
TMPFILE="/tmp/.queue2post_report.queuedata.$$"


echo "Queue2Post Report $REPORT_DATE" >$REPORT_FILE
echo " " >>$REPORT_FILE

for serverdata in `echo $config_file_list`
do
	servername=`echo $serverdata | awk -F: '{ print $1 }'`
	config_file=`echo $serverdata | awk -F: '{ print $2 }'`

	if [ ! -f "$config_file" ]
	then
		echo "Unable to locate config file: $config_file"
		continue
	fi

	/usr/local/bin/queue2post -d ${config_file} >$TMPFILE 

	queue_count=`cat $TMPFILE  | awk '{ print $2 }' | grep "1" | wc -l`

	if [ "$queue_count" -gt "0" ]
	then

		echo "$servername" >>$REPORT_FILE
		cat $TMPFILE >>$REPORT_FILE
		echo " " >>$REPORT_FILE
		RECORDS_FOUND="1"
	fi


done



cat $REPORT_FILE

if [ "$RECORDS_FOUND" -eq "1" -a "$SEND_EMAIL" -eq "1" ]
then
	do_mail "Queue2Post Report $REPORT_DATE"  $REPORT_FILE
fi

rm -f $TMPFILE
rm -f $REPORT_FILE
