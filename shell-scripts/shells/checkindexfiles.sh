#!/bin/sh
#
# Program Name	: checkindexfiles.sh
# Description	:
# Author	: Linda S. Jefferis
# Date		:
# Modifications :  
#
# Variables Used:
PATH=/usr/rmcobol:$PATH
SYSTEM=`/usr/lnk/shell/get_hostname.sh`
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR=/usr/lnk/shell
DATE=`date +%Y%m%d`
OUT_LOG=/tmp/checkindexfiles_${USER}_${DATE}.log
RECLOGDIR=/tmp
RECOVER_PROG="/usr/rmcobol/recover1"
RETVAL=0
COMPU13_RETVAL=0
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/bin/mail"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: checkindexfiles.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{

    OLDIFS=${IFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	set $VAR
	NVAR=$1
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

VERIFYFLOG=/tmp/compu13log_${USER}_${DATE}.txt; export VERIFYFLOG

date > ${OUT_LOG}
   ${SHELL_DIR}/compu13.sh -o $VERIFYFLOG >> ${OUT_LOG} 2>&1
   COMPU13_RETVAL=$?
   if [ $COMPU13_RETVAL -ne 0 ] 
   then
      echo "" >> ${OUT_LOG}
      cat $VERIFYFLOG >> ${OUT_LOG}
      for line in `cat $VERIFYFLOG`
      do
	FNAME=`echo $line | awk -F"|" '{ print $1 }'`
	ERRCD=`echo $line | awk -F"|" '{ print $2 }'`
	ERR=`echo $ERRCD | cut -c1-2`
	if [ $ERR = "98" ]
	then
		FILEDIR=`dirname ${!FNAME}`
		echo "Running recover1 on ${FILEDIR}/${FNAME}" >> ${OUT_LOG}
		${RECOVER_PROG} ${FILEDIR}/${FNAME} ${RECLOGDIR}/drop-${FNAME} -L ${RECLOGDIR}/log-${FNAME} -Q -Y
		if test $? -eq 0
		then
			echo "Recovery of ${FILEDIR}/${FNAME} is completed" >> ${OUT_LOG}
		else
			echo "** Error with recovery of ${FILEDIR}/${FNAME}" >> ${OUT_LOG}
			RETVAL=80
		fi		
		echo "" >> ${OUT_LOG}
		echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
		cat ${RECLOGDIR}/log-${FNAME} >> ${OUT_LOG}
		rm -f ${RECLOGDIR}/log-${FNAME}
		rm -f ${RECLOGDIR}/drop-${FNAME}
		date >> ${OUT_LOG}
	   fi
      done
   fi

if test -s ${VERIFYFLOG}
then
	${MAIL_PROG} -s "${SYSTEM}: Index File Check/Recovery" ${MAIL_TO} < ${OUT_LOG}
fi

exit $RETVAL
