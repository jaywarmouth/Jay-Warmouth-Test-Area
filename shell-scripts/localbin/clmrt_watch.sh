#!/bin/sh

QNUM="$1"

# The watchfile is created by traffic but is no longer used by the monitor tlz 
WATCHFILE="/tmp/.traffic01.skip_tc"

# The lockfile will be removed hourly by crontab to re-issue pages
LOCKFILE="/tmp/.traffic01.skip_tc.lock.${QNUM}"
LOCKFILE_MAX="/tmp/.traffic01.skip_tc.lock.max.${QNUM}"
#MAILTO="networking@pdmi.com alerts@pdmi.com"
MAILTO="srandlett@pdmi.com"
#PAGETO not used
PAGETO=""

sendemail()
{
RCPT="$1"
MSG="$2"

for name in $RCPT
do
	echo "Sending email to $name"
	echo "$MSG" | mail -s "claimrt" $name
done

}

sendpage()
{

return

RCPT="$1"
MSG="$2"

	/usr/local/bin/pageuser.sh "claimrt" "$MSG" $RCPT

}


msgcount=`/usr/local/bin/msgcnt_bin $QNUM`

# remove lockfile/watchfile, queues are clean
if [ "$msgcount" -lt "10" ]
then
	if [ -f "$LOCKFILE" -o -f "$LOCKFILE_MAX" ]	
	then
		sendemail "$MAILTO" "claimrt queue $QNUM has cleared."
		sendpage "$PAGETO" "claimrt queue $QNUM has cleared."
		rm -f $LOCKFILE $WATCHFILE $LOCKFILE_MAX
	fi
fi

if [ "$msgcount" -gt "100" ]
then

	# Only send email if we have not sent before.
	if [ ! -f "$LOCKFILE" ]	
	then
		sendpage "$PAGETO" "claimrt queue $QNUM is filling up. Currently $msgcount queued. Max queue size is 3,000."
		sendemail "$MAILTO" "claimrt queue $QNUM is filling up. Currently $msgcount queued. Max queue size is 3,000."
		touch $LOCKFILE
	fi
fi

if [ "$msgcount" -ge "3000" ]
then

	# Only send email if we have not sent before.
	if [ ! -f "$LOCKFILE_MAX" ]	
	then
		sendpage "$PAGETO" "claimrt queue $QNUM is FULL. Currently $msgcount queued. No more transactions will be queued."
		sendemail "$MAILTO" "claimrt queue $QNUM is FULL. Currently $msgcount queued. No more transactions will be queued."
		touch $LOCKFILE_MAX
	fi
fi
