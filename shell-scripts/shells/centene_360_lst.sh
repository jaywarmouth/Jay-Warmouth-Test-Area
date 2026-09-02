#!/bin/ksh
#
# Program Name	: centene_lst.sh
# Description	: Unzips, Moves, and Creates log listing of Centene/spo0360 eligibility files.
#                 Command Line Arguments:
#                 -d <mmdd> - date on file downloaded.
# Author	: Linda S. Jefferis
# Date		: 08/31/2006
# Modifications : 12/27/2006 - Switch to web transfer  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH="/usr/lnk/elig_in_1"
SYS_DIR="sys0061"
ELIG_FILE="APM?????"
REMOTE_DIR="/usr/lnk/wt/cen-wt"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: centene_360_lst.sh [-d <mmdd>]

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
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done

if [ ${DATE} = "null" ]
then
   usage
fi

echo
echo "--> Moving file"
if test -s ${REMOTE_DIR}/${ELIG_FILE}
then
   mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/cse${DATE}-X12
   cp ${ELIG_DIR}/cse${DATE}-X12 ${ELIG_ARCH}
else
   echo ""
   echo "--> ${REMOTE_DIR}/${ELIG_FILE} does not exist"
fi

echo
echo "--> Creating log listing"
LOG_NAME=cen-spo0360${DATE}.log
cd ${ELIG_DIR}
echo "Centene/SPO0360 Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
echo "----------------------------" >> ${ELIG_LOG}/${LOG_NAME}
echo "" >> ${ELIG_LOG}/${LOG_NAME}
ls -l cse${DATE}-X12 >> ${ELIG_LOG}/${LOG_NAME}
cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}


exit 0
