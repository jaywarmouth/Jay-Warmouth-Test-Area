#!/bin/bash
#
# Program Name	: login_netw.sh
# Description	: Shell to allow network access to system(s)
# Author	: Anthony DePinto
# Date		: 7-17-96
# WARNINGS	:
#		  Be sure that the $DENYLOG file exists and permissions are set to 666 owner root, group admin
#	
# Modifications : 9-04-97 
#		  changed over to new flexgen /usr/pdm/flexgen
#		  9-16-97 SRR
#	  	  added code to touch a file in users home dir to determine 
#		  when they last logged in.	
#		  10-8-97 SRR
#		  added code to check if user is over CU_LIMIT connections,
#		  the user is ignored if CU_LIMIT is not set (set to 0)
#		  This should make the login_dialxx scripts obsolete. 	
#	          8/28/98 SRR
#			Changed toll_free.deny to toll_free.allow.  Makes more sense that way.	
#	          9/03/98 SRR
#			Added code to do user expiration dates.  This way we don't have to do it via the password file.
#		  10/02/98 SRR
#			Added code to allow EXPIRE_DAYS to be set in the parent shell but will default otherwise.
#			Added "codes" to error message which instructs users to give the code to us when they call.
#			This should simplify the error handling when users call.	
#		  10/21/98 SRR
#			Added logging of users which try to access the 800 lines and are denied.
#			This file is not "cleaned up" (for now) so we will have to watch it.
#		  10/23/98 SRR
#			Added extensive logging.  resize_log() which keeps the log file from getting too obnoxious.
#			Logging all messages to the users and errors.
#		  10/29/98 SRR
#			Made login_netw_log C program to add info to log.
#		  12/10/98 SRR
#			add ppp support	
#
#		  01/18/99 SRR
#			Added support for .lockout file to prevent user from 
#			logging in.
#	
#		  01/19/99 SRR
#			Redid toll_line_check() and made it line_check()
#			Will check local or toll lines depending on args
#		  06/30/04 SRR
#		  	Added better contents for .lastlogin
#		  2020-07-19 SRR
#			Removed weekend access check.
#		
#
# Variables Used:

#TERM=vt220
#export TERM

MAILUSER="operator@pdmi.com"
LOGIN_FILE="/usr/local/etc/login_status/stoplogin"
ACCDATA=/usr/local/pub/access_weekend.allow
DENYLOG=/usr/local/adm/log/login_netw.log
DENYLOG_SIZE="5000"

#DIALALLOW="/usr/local/pub/dialup.allow"
#DIALLINES="/usr/local/pub/dialup.lines"

TMPFILE="/tmp/login_netw.log.$$"
ERRLOG=/tmp/access_weekend.ERROR
USER_LOG="/usr/local/bin/user_log.out"
LASTLOGIN=".lastlogin"
LOCKOUT_FILE=".lockout_user"
#TTY=`who am i | awk '{ print $2}'`
TTY=`ps --no-headers -fp $$ | awk '{ print $6 }'`
DAY=`date +%a`
CR="
"
ENTRY=0
LOG_CODE=I
DEFAULT_EXPIRE_DAYS="45"
RESIZE_LOCK=/tmp/login_netw.resize.lock
LOGTIME=".logtime"


resize_log()
{
# Keep the log from getting too big
# This is not used, login_netw_log handles it now.
local_counter="0"
while [ -f $RESIZE_LOCK ]
do
	sleep 1
	local_counter=`expr $local_counter + 1`
	if [ "$local_counter" -gt "10" ] 
	then
		echo "$RESIZE_LOCK was not removed in 10 seconds, aborting attempt!" | mail $MAILUSER
		echo "ERROR: $RESIZE_LOCK was not removed in 10 seconds, aborting resize_log() on `date`" >>$DENYLOG
		return
	fi	
			
done
	touch $RESIZE_LOCK

	tail -${DENYLOG_SIZE} $DENYLOG >$TMPFILE
	cp $TMPFILE $DENYLOG
	rm -f $TMPFILE $RESIZE_LOCK
}

add_log_entry()
{
#	/usr/local/bin/login_netw_log "$1	$LOGNAME `date`" 
echo " "
}
check_system()
{
# Check if they are coming in from old servers

#set -x
	sitecount=`who am i | egrep  "pos11|pos10" | grep -c -v "grep"`
	if [ "$sitecount" -ne "1" ]
	then
			cat <<-SYSCHK_ACCOUNT

ATTENTION: 

You are accessing the PDMI Online System from an old link.  Please
go to http://www.pdmi.com and update your bookmarks.

Thank you,
Networking Services, Pharmacy Data Managment
(330) 757-0724 x5409
networking@pdmi.com


One moment please...
			SYSCHK_ACCOUNT
			add_log_entry "BADSYS101:"
			sleep 30
	fi
#set +x
}

check_lockout()
{
# Check to see if LOCKFILE exists in their home dir, if so, user cannot
# log in

	if [ -f "${HOME}/${LOCKOUT_FILE}" ]
	then
			cat <<-LOCKED_ACCOUNT

ATTENTION: 

Your login has been disabled.
If you feel you have reached this message in error, please contact
client services at Pharmacy Data Management
and refer to code: LCK101


            Thank you,
		Client Services, Pharmacy Data Managment
		(330) 757-0724 x5400
		benefits@pdmi.com


			LOCKED_ACCOUNT
			add_log_entry "LCK101:"
			ENTRY=1
			sleep 60
	fi
}
check_last_login()
{
# checks to see when user was last in.  If file doesn't exist, we allow them in.

	if [ -f "${HOME}/${LASTLOGIN}" ]
	then
		find_ret="`find ${HOME} -name ${LASTLOGIN} -mtime -${EXPIRE_DAYS}`"
		if [ "$find_ret" = "" ]
		then
			cat <<-EXPIRED_ACCOUNT

ATTENTION: 

Your login has been disabled because it has not been used
for the past ${EXPIRE_DAYS} days.
If you need to reactivate your account, please contact client
services and give them the following code: EXP${EXPIRE_DAYS}. 


            Thank you,
		Client Services, Pharmacy Data Management
		(330) 757-0724 x5400
		benefits@pdmi.com


			EXPIRED_ACCOUNT
			add_log_entry "EXP${EXPIRE_DAYS}:   "
			ENTRY=1
			sleep 60
		fi
	fi
}

last_login()
{
#	/usr/bin/touch "${HOME}/${LASTLOGIN}"
L_DATE=`date "+%D %T %Z"`
L_OUTTXT="`/usr/bin/id -un`|Active|$L_DATE|$FAXTO"
echo $L_OUTTXT>"${HOME}/${LASTLOGIN}"
}

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: shell.sh 

ENDOFUSAGE
  exit 1
}

check_duplicate()
{  
   if [ -f ${HOME}/.linfo ]
   then
     LOG_CODE=J
cat <<-MULTILOG

-> Multiple login

Please wait while I log your previous session off.

This delay can be eliminated by logging off the PDM
system correctly.

Use the "Logoff Pharmacy Data System" menu selection
to properly terminate your PDM session.
If you have questions about this, please contact
networking services at Pharmacy Data Management
and refer to code: ILO101

Client Services can be reached at
(330) 757-0724 x5400

Removing old processes.........
Please wait.....

MULTILOG


	add_log_entry "ILO101:"
	sleep 15

     OLDTERM=`cat ${HOME}/.linfo`
     rm ${HOME}/.linfo
     OLDIFS=${IFS}
    IFS=${CR}
     if [ ${OLDTERM} != ${TTY} ]
     then
       for LINE in `ps --no-headers -fu ${USER} | sort  -r | grep -v ${TTY}`
       do
         IFS=" "
         PID=`echo ${LINE} | awk '{ print $2 }'`
         if [ ${PID} -gt 1 ]
         then
           kill -9 ${PID}
         fi
         IFS=${CR}
       done
     fi

 IFS=$OLDIFS
   fi
}

create_entry()
{  if [ ${ENTRY} -eq 0 ]
   then
     cd ${HOME}
     echo ${TTY} > .linfo
     S_DATE=`date +%m/%d/%Y`
     S_TIME=`date +%R:%S`
     echo -n "${LOGNAME}\t${TTY}\t${S_DATE} ${S_TIME}\t" >$LOGTIME
   fi
}

check_access()
{ 

# case ${DAY} in
#     "Sun" | "Sat")

#	ACCESS=0
#	for allow_name in `cat "$ACCDATA" | grep -v "^#"`
#	do
#		if [ "$allow_name" = "$LOGNAME" ]
#		then
#			ACCESS=1  
#			break;
#		fi 
#	done
#
#       if [ ${ACCESS} -eq 1 ]
#       then
#	 ENTRY=0
#       else
#cat <<-WEEKEND_ACCESS
#	 
#WARNING: Weekend access attempted.
#	  
#You do not have authority to access the PDM
#system on the weekend.
#If you need weekend access, please notify PDM
#at least a day in advance so arrangements can
#be made.  If you feel you have reached this 
#message in error, contact networking services
#and give them the following code: WKD101.
#	 
#Phone: (330) 757-0724 x5409
#Email: networking@pdmi.com
#
#	Thank you.
#
#
#WEEKEND_ACCESS
#	add_log_entry "WKD101:"
#	 ENTRY=1
#	sleep 60
#       fi
#   esac
	if [ -f "$LOGIN_FILE" ]
	then
cat <<-NOLOGIN

ATTENTION: 

Logins have been disabled for maintenance purposes.
Please try logging in at a later time.  If you have
any questions, contact networking services and give
them the following code: MNT101.


            Thank you,
		Client Services, Pharmacy Data Managment
		(330) 757-0724 x5400
		benefits@pdmi.com


NOLOGIN

	 add_log_entry "MNT101:"
	 ENTRY=1
	sleep 60
       fi

}

load_ppp()
{  
   exec /usr/lib/ppp/ppp
}

load_flexgen()
{  rm -f FG4*
   cd /usr/lnk/flexgen
   exec ./fg4_remote.sh
}

check_limit()
{  

if [ "${CU_LIMIT}" -ne "0" ]
then
   if [ `who | grep ${SPO_NAME} | wc -l` -gt ${CU_LIMIT} ]
   then

cat <<-ACCLIMIT

ATTENTION:

-> Account limit met!

Only ${CU_LIMIT} user(s) are allowed on from your
sponsor at a time.  If you feel you have reached
this message in error, contact client services
and give them the following code: LIM${CU_LIMIT}.

    Thank you for your cooperation,
		Client Services, Pharmacy Data Managment
		(330) 757-0724 x5400
		benefits@pdmi.com

ACCLIMIT
	 add_log_entry "LIM${CU_LIMIT}:    "
     ENTRY=1
	sleep 60
   fi
fi
}

line_check()
{

ISOK="FALSE"
ISLINE="FALSE"
DENYUSER="TRUE"
ALLOW_FILE="$1"
LINES_FILE="$2"
CODE_RETURN="$3"
LSECTION="DEFAULT_VALUE"
ASECTION="DEFAULT_VALUE"
USER_SECTION="DEFAULT_VALUE"

OLDIFS="$IFS"
IFS="
"

	if [ ! -f "$ALLOW_FILE" -o ! -f "$LINES_FILE" ]
	then
		echo "$ALLOW_FILE or $LINES_FILE doesn't exist! CANNOT PROCESS line_check() in $0 properly!"|mail $MAILUSER
		
	else

		for UNAME in `cat ${ALLOW_FILE} | grep -v "^#"`
		do
			FIRSTCHAR=`echo $UNAME | cut -c 1`
			if [ "$FIRSTCHAR" = "[" ]
			then
				ASECTION="$UNAME"
				continue	
			fi
			if [ "$UNAME" = "$LOGNAME" ]
			then
				USER_SECTION="$USER_SECTION ${ASECTION}"
			fi
		done	

		CIFS="$IFS"
		IFS=$OLDIFS
		for ASECTION in `echo ${USER_SECTION}`
		do
			IFS=$CIFS
			for TNAME in `cat ${LINES_FILE} | grep -v "^#"`
			do	
				if [ "$TTY" = "$TNAME" ]
				then
					ISLINE="TRUE"
				fi

				FIRSTCHAR=`echo $TNAME | cut -c 1`
				if [ "$FIRSTCHAR" = "[" ]
				then
					LSECTION="$TNAME"
					continue	
				fi
				if [ "$ASECTION" = "$LSECTION" ]
				then
					if [ "$TTY" = "$TNAME" ]
					then
						ISOK="TRUE"
					fi
				fi
			done
			IFS=$OLDIFS
		done

		if [ "$ISOK" = "FALSE" -a "$ISLINE" = "TRUE" ]
		then

			cat <<-DENYPRINT

ATTENTION:

You are not authorized to use this phone number to connect to Pharmacy Data 
Management.
If you have any questions, please contact client services and give
them the following code: TTY=$TTY

	Thank you for your attention in this matter.

		Client Services, Pharmacy Data Managment
		(330) 757-0724 x5400
		benefits@pdmi.com

DENYPRINT
			echo "$LOGNAME tried to login via modems on $TTY!" | mail $MAILUSER
			add_log_entry "TTY=$TTY:"
			ENTRY=1
			sleep 60

		fi
	fi
}


#
# Main routine
#

ENTRY="0"

if [ "$EXPIRE_DAYS" = "" ]
then
	EXPIRE_DAYS=$DEFAULT_EXPIRE_DAYS
fi


if [ "$ENTRY" -ne "0" ]
then
	exit 1
fi


echo 
echo "Checking for duplicate logins"
echo

#check_system

check_duplicate

#check_limit

check_lockout

if [ "$ENTRY" -ne "0" ]
then
	exit 1
fi

check_last_login

if [ "$ENTRY" -ne "0" ]
then
	exit 1
fi

check_access  

if [ "$ENTRY" -ne "0" ]
then
	exit 1
fi

last_login

#line_check "$DIALALLOW" "$DIALLINES" 

if [ "$ENTRY" -ne "0" ]
then
	exit 1
fi

create_entry

#if [ "$USE_PPP" -eq "1" ]
#then
#	load_ppp
#else
	load_flexgen
#fi
