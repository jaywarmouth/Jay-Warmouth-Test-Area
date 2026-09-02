#!/bin/ksh
#
# Program Name	: check_compu11.sh
# Description	:
# Author	:
# Date		:
# Modifications : 10/24/2005 - Changes for Linux  (LSJ)
#		: 11/30/2005 - Removed PAGE_HOST references  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
HOST=`/usr/lnk/shell/get_hostname.sh`
SUBJECT="$HOST compu11"
PAGE_PROG="/usr/local/bin/pageuser.sh"
PAGEUSER="linda"
MAILUSER="operations@pdmi.com"
ERR_MSG_FILE="/tmp/err_msg"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: check_compu11.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

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

    echo "-=> Finished."

}

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

${SHELL_DIR}/compu11.sh > /tmp/compu11.rpt 2>&1
grep "ERROR ON" /tmp/compu11.rpt > /tmp/compu11.error
if test -s /tmp/compu11.error
then
   PREV_FILE="null"
   echo "Compu11 errors with:" > ${ERR_MSG_FILE}
   OLDIFS=$IFS
   IFS=${CR}
   for line in `cat /tmp/compu11.error`
   do
      FILE=`echo $line | awk '{ print $3 }'`
      if [ $FILE != $PREV_FILE ]
      then
	echo `cat ${ERR_MSG_FILE}`" $FILE" > ${ERR_MSG_FILE}
	ERR_MSG=`cat ${ERR_MSG_FILE}`
	PREV_FILE=$FILE
      fi
   done
   IFS=${OLDIFS}
   echo $ERR_MSG | /bin/mail -s "$SUBJECT" $MAILUSER
   $PAGE_PROG "$SUBJECT" "$ERR_MSG" $PAGEUSER
fi

exit 0
