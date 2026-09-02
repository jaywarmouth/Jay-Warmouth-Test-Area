#!/bin/sh

#       Name: ef_check.sh
#       By  : Steven Randlett
#       Date:
#       Purpose:
#  		Check Eagle Force lines/processing.
#
#
# Modifications	: 12/21/2015 - Comment out mailuser Operations@pdmi.com. Has been added to the operator page group. (DME)
#


# Not needed added Operations group to the page list.
#
do_mail()
{
subject="$1"
message="$2"


for sendto in `echo $MAILUSER`
do
	echo $message | /bin/mail -s "$subject" $sendto 
done


}


#MAILUSER="operations@pdmi.com"
MAILUSER="EFTechAlerts@pdmi.com"
#MAILUSER="srandlett@pdmi.com"

# Number of records to look at
LOOKBACK_RECORDS=100

# When to treat "timeout" error as cleared
TIMEOUT_LOWER_LIMIT=15

# When to treat "timeout" error as active
TIMEOUT_PAGE_LIMIT=20

# When to treat "EF errors" error as cleared
ERRORS_LOWER_LIMIT=10

# When to treat "EF errors" error as active
ERRORS_PAGE_LIMIT=20

PAGE_FILE_TIMEOUT="/usr/local/etc/ef_check_timeout.page"
PAGE_FILE_ERRORS="/usr/local/etc/ef_check_errors.page"

eval `/usr/lnk/shell/efresp.sh -v -l ${LOOKBACK_RECORDS}`

#EF_TIMEOUTS=25
#EF_ERRORS=30

# A page file is set due to timeouts
if [ -f "$PAGE_FILE_TIMEOUT" ] 
then
	if [ "$EF_TIMEOUTS" -le "$TIMEOUT_LOWER_LIMIT" ] 
	then
		echo "EF timeout cleared"
		rm -f $PAGE_FILE_TIMEOUT
		do_mail "EF timeout cleared" "Eagle Force timeout has now cleared."		
	fi

else
	if [ "$EF_TIMEOUTS" -ge "$TIMEOUT_PAGE_LIMIT" ] 
	then
		touch $PAGE_FILE_TIMEOUT	
		echo "EF timeouts at $EF_TIMEOUTS"
		do_mail "EF timeout error" "Eagle Force timeouts at $EF_TIMEOUTS/$LOOKBACK_RECORDS"		

	fi

fi

# A page file is set due to errors
if [ -f "$PAGE_FILE_ERRORS" ] 
then
	if [ "$EF_ERRORS" -le "$ERRORS_LOWER_LIMIT" ] 
	then
		echo "EF errors cleared"
		rm -f $PAGE_FILE_ERRORS
		do_mail "EF errors cleared" "Eagle Force errors have now cleared."		
	fi

else
	if [ "$EF_ERRORS" -ge "$ERRORS_PAGE_LIMIT" ] 
	then
		touch $PAGE_FILE_ERRORS
		echo "EF errors at $EF_ERRORS"
		do_mail "EF errors" "Eagle Force errors at $EF_ERRORS/$LOOKBACK_RECORDS"		

	fi

fi

exit 0
