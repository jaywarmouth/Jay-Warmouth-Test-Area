#!/bin/sh

#       Name: queue2post_check.sh
#       By  : Steven Randlett
#       Date: 12/4/2015
#       Purpose:
#		checks to make sure RTC transactions are not queuing up
#
#  		Creates the file /home/srandlet/pub/line_check.page
#  		This file is erased every morning at 10:00am
#  		If this file exists, the users will not be notified.
#  		This file can be removed at any time to allow notification of dropped lines.
#
#
#


usage()
{
	echo "queue2post_check.sh uid config"
	echo "uid - a unique identifier (no spaces) for the check"
	echo "config - location of queue2post configuration file"
	exit 1
}

do_mail()
{
subject="$1"
message="$2"


for sendto in `echo $MAILUSER`
do
	echo $message | /bin/mail -s "$subject" $sendto 
done


}


####
#
# MAIN
#
####


if [ "$#" -ne "2" ]
then
	usage
	exit 1
fi

unique_id="$1"
config_file="$2"

# Number of claims to page on
PAGE_COUNT="20"
CLEAR_COUNT="0"

SECONDS_TO_REPAGE="3600"

MAILUSER="alerts@pdmi.com"

PGFILE="/usr/local/etc/queue2post_check.${unique_id}.page"

#set -x
# These vars are only used for text output.  The program
# uses the PGFILE state to determine if a page should go out.

queue_count=`/usr/local/bin/queue2post -d ${config_file}  | awk '{ print $2 }' | grep "1" | wc -l`

if [ "$queue_count" -gt "$PAGE_COUNT" ]
then

	if [ -f "$PGFILE" ]  # page file exists
	then
		if [ "`stat --format=%Y $PGFILE`" -le "$(( `date +%s` - ${SECONDS_TO_REPAGE} ))" ]   # file is over 1 hour old
		then
			touch $PGFILE
			do_mail "Queue2Post $unique_id queued trans"  "Queued transactions at $queue_count on $unique_id"
			echo "Queued transactions at $queue_count - re-paging" 
		fi

	else
			touch $PGFILE
			do_mail "Queue2Post $unique_id queued trans"  "Queued transactions at $queue_count on $unique_id"
			echo "Queued transactions at $queue_count"

	fi

fi

if [ "$queue_count" -le "$CLEAR_COUNT" -a -f "$PGFILE" ]
then
	rm -f $PGFILE
	do_mail "Queue2Post $unique_id CLEAR"  "Queued transactions at $queue_count on $unique_id"
	echo "Queued transactions at $queue_count - CLEAR" 
fi
