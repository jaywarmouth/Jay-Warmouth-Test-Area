#!/bin/ksh
#
# Program Name	: login_net.sh
# Description	: Shell to allow network access to system(s)
# Author	: Anthony DePinto
# Date		: 7-17-96
# Modifications :
#
# Variables Used:
USER_LOG="/usr/pdm/bin/user_log.out"
LOGFILE=/usr/lnk/daily/remote
TTY=`who am i | awk '{ print $2}'`
DAY=`date +%a`
CR="
"
ENTRY=0
LOG_CODE=I

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
     ${USER_LOG} ${LOGNAME} ${TTY} ${LOG_CODE}
     cd ${HOME}
     echo ${TTY} > .linfo
   else
#     LOGFILE=${LOGFILE}/`date +%B`/log.`date +%m%d%y`
#     echo "Unauthorized access attempt: <${LOGNAME}> - ${TTY} Time In: "`date '+%D %T'` >> ${LOGFILE}
      ${USER_LOG} ${LOGNAME} ${TTY} W
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

check_duplicate

check_access  

load_flexgen
