#!/bin/ksh
#
# Program Name	: login_dial.sh
# Description	: Shell to allow dial-up access to system(s)
# Author	: Anthony DePinto
# Date		: 7-30-96
# Modifications :
#
# Variables Used:
LOGFILE=/usr/lnk/daily/remote
USER_LOG=/usr/pdm/bin/user_log.out
TTY=`who am i | awk '{ print $2}'`
DAY=`date +%a`
CR="
"
ENTRY=0

check_limit()
{  if [ `who | grep ${SPO_NAME} | wc -l` -gt ${CU_LIMIT} ]
   then
     ${USER_LOG} ${LOGNAME} ${TTY} L
     echo "-> Account limit met"
     echo 
     echo "  Only ${CU_LIMIT} user(s) are allowed on from your"
     echo "sponsor at a time.  Please logoff and"
     echo "try again later."
     echo
     echo "Thank you for your cooperation,"
     echo "			Anthony DePinto"
     echo "			Network Manager"
     echo "			Pharmacy Data Management, Inc."
     echo
     exit 1
   fi
}

check_duplicate()
{  
   if [ -f ${HOME}/.linfo ]
   then
     echo "-> Multiple login"
     echo 
     echo "  Please wait while I log your previous session off."
     echo "This delay can be eliminated by logging off PDM"
     echo "correctly."
     echo
     OLDTERM=`cat ${HOME}/.linfo`
     rm ${HOME}/.linfo
     OLDIFS=${IFS}
     IFS=${CR}
     if [ ${OLDTERM} != ${TTY} ]
     then
       for LINE in `ps -t ${OLDTERM} | sort +0 -r`
       do
	 IFS=" "
	 PID=`echo ${LINE} | awk '{print $1}'`
	 if [ ${PID} -gt 1 ]
	 then 
	   kill ${PID}
         fi
	 IFS=${CR}
       done
     fi
   fi
}

create_entry()
{  if [ ${ENTRY} -eq 0 ]
   then
#     LOGFILE=${LOGFILE}/`date +%B`/log.`date +%m%d%y`
#     echo "<${LOGNAME}> - ${TTY} Time In: "`date '+%D %T'` >> ${LOGFILE}
     ${USER_LOG} ${LOGNAME} ${TTY} I
     cd ${HOME}
     echo ${TTY} > .linfo
   else
#     LOGFILE=${LOGFILE}/`date +%B`/log.`date +%m%d%y`
#     echo "Unauthorized access attempt: <${LOGNAME}> - ${TTY} Time In: "`date '+%D %T'` >> ${LOGFILE}
     ${USER_LOG} ${LOGNAME} ${TTY} U
     exit 1
   fi
}

check_access()
{  case ${DAY} in
     "Sun" | "Sat")
       if [ ${ACCESS} -eq 1 ]
       then
	 ENTRY=0
       else
	 echo
	 echo "WARNING: Weekend access attempted."
	 echo 
	 echo "-You do not have authority to access the PDM"
	 echo "-system on the weekend."
	 echo "-If you need weekend access, please notify PDM"
	 echo "-at least a day in advance so arrangements can"
	 echo "-be made."
	 echo
	 echo "      Thank you,"
	 echo "                Anthony DePinto"
	 echo "                Network Manager"
	 echo "                (330) 629-7327"
         echo "                adepinto@pdmi.com"
	 echo
	 ENTRY=1
       fi
   esac
   create_entry
}

load_flexgen()
{  rm -f FG4*
   cd /usr/pdm/fg4
   exec fg4_remote.sh
}

#
# Main routine
#

echo 
echo "Checking for duplicate logins"
echo

check_limit

check_duplicate

check_access  

load_flexgen
