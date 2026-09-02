#!/bin/ksh
#
# Program Name	: dv.sh
# Description	: Use DoubleVision to pull up users screen
# Author	: Anthony DePinto
# Date		: 2-26-97 
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date`
LOG_FILE=/usr/lnk/daily/prg_log/dv.log
PWD_FILE=/etc/passwd
ACTIVE=0
ACCOUNT=$1

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dv.sh UserName

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
      FIRSTCH=`echo ${VAR} | cut -c1`
      if [ ${FIRSTCH} != "#" ]
      then
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	NVAR=`echo ${VAR} | awk '{print $1}'`
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# log_attempt - log attempt to use dv
log_attempt()
{  
   echo "${USER},${ACCOUNT},${DATE}" >> ${LOG_FILE}
}

#
# check_user - Check to see if user name is a valid account
check_user()
{
   grep -w ${ACCOUNT} ${PWD_FILE} > /dev/null 
   if [ $? -eq 1 ]
   then
     echo  
     echo "-*> ${ACCOUNT} is not a valid account on this system"
     echo
     exit 1
   fi
}

#
# check_status - Check to see if the user is logged into the system
check_status()
{
   OLDIFS=${IFS}
   IFS=${CR}
   echo "--> Working..."
   for LINE in `who`
   do
     IFS=${OLDIFS}
     TACCOUNT=`echo ${LINE} | awk '{print $1}'`
     if [ ${TACCOUNT} = ${ACCOUNT} ]
     then
       TTERM=`echo ${LINE} | awk '{print $2}'`
       ACTIVE=1
       echo "--> User: ${TACCOUNT} Session: ${TTERM}"
       ps -ft ${TTERM}
       echo "--> Do you want to view this session? (Y/N)"
       read REPLY
       case ${REPLY} in
	 "Y" | "y") connect
		    exit 0
		    ;;
         *) 	    REPLY="n"
		    ;;
       esac
       echo "--> Working..."
     fi
     IFS=${CR}
   done
   IFS=${OLDIFS}
   if [ ${ACTIVE} -eq 0 ]
   then
     echo
     echo "-*> ${ACCOUNT} is not logged into the system."
     echo
     exit 1
   fi
}

#
# connect
connect()
{
   dv ${TTERM}  
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -ne 1 ]
then 
  usage
fi

log_attempt

check_user

check_status

echo "-=> Finished."

exit 0
