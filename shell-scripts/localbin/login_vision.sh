#!/bin/ksh
#
# Program Name	: login_vision.sh
# Description	: Shell to allow network access to system(s) for pVision
# Author	: Steven Randlett
# Date		: 2017-02-08
# WARNINGS	:
#
# Variables Used:

STOP_LOGIN_FILE="/usr/local/etc/login_status/stoplogin"

TMPFILE="/tmp/login_vision.log.$$"
CR="
"

check_dup_user()
{

runfg4_count=`ps -ef|grep -v grep | egrep -c "${USER}.*runfg4"`

if [ "$runfg4_count" -ne "0" ]
then
cat <<-NOLOGIN

**START_MESSAGE**

	There was an issue logging into the system.
	Please try logging in again.

MESSAGE CODE: DUPE ${USER}

**END_MESSAGE**

Press ENTER to continue
NOLOGIN

read junk
cleanup
exit 1

fi

}

check_stoplogin()
{ 

	if [ -f "$STOP_LOGIN_FILE" ]
        then
cat <<-NOLOGIN

**START_MESSAGE**

Logins have been disabled for maintenance purposes.
Please try logging in at a later time.  


            Thank you,
                Client Services, Pharmacy Data Managment
                (330) 757-0724 x5400
                benefits@pdmi.com

MESSAGE CODE: MAINT

**END_MESSAGE**

Press ENTER to continue
NOLOGIN

	read junk
	cleanup
	exit 0

       fi

}


cleanup()
{

# lock password
echo " "

}

start_flexgen()
{  rm -f FG4*
   cd /usr/lnk/flexgen_vision
   ./fg4_remote.sh
}


#
# Main routine
#

SKIP_DUP_CHECK="0"

if [ "$1" = "-s" ]
then
	SKIP_DUP_CHECK="1"
fi


check_stoplogin

if [ "$SKIP_DUP_CHECK" -eq "0" ]
then
	check_dup_user
fi

start_flexgen

cleanup

exit 0

