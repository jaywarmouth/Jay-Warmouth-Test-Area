#!/bin/ksh
#
# Program Name	: cp_cardh09.sh
# Description	: Copy of CARDH09KEY
# Author	: Linda S. Jefferis
# Date		: 07/22/98
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%y`
STAT_DIR="/usr/lnk/rpt"
STAT_FILE="cardh09_status"
CARDH09_DIR="/usr/lnk/tmp"
MAIL_TO="ljefferis@pdmi.com"
REMOTE_SYS=`/usr/local/bin/picksystem.sh raven`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_cardh09.sh 

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
parse_env

rcp ${REMOTE_SYS}:${STAT_DIR}/${STAT_FILE} ${STAT_DIR}/${STAT_FILE}
CS_DATE=`cat ${STAT_DIR}/${STAT_FILE}`
echo ${CS_DATE}
if [ ${DATE} = ${CS_DATE} ]
then
   rcp ${REMOTE_SYS}:${CARDH09KEY} ${CARDH09KEY}
else
   echo "unable to execute copy of CARDH09KEY" | mail ${MAIL_TO}
fi

exit 0
