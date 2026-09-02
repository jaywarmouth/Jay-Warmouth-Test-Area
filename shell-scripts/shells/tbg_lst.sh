#!/bin/ksh
#
# Program Name	: tbg_lst.sh
# Description	: Prepares eligibility file sent from TBG for Benefits and processing
#		  Files are for sys0075/spo0493 - Gage County
#                 Command Line Arguments:
#                 -d <mmdd> - date on file downloaded.
# Author	: Linda S. Jefferis
# Date		: 12/29/2006
# Modifications : 11/11/2009 - Added ToPDMI sub-directory
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
SYS_DIR="sys0075"
ELIG_FILE="834out??????????.txt"
REMOTE_DIR="/usr/lnk/wt/tbg-wt/ToPDMI"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tbg_lst.sh -d <mmdd>

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
   mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/gce${DATE}-X12
   cp ${ELIG_DIR}/gce${DATE}-X12 ${ELIG_ARCH}
else
   echo ""
   echo "--> ${REMOTE_DIR}/${ELIG_FILE} does not exist"
fi

echo
echo "--> Creating log listing"
LOG_NAME=tbg-spo0493${DATE}.log
cd ${ELIG_DIR}
echo "Gage County/SPO0493 Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
echo "----------------------------" >> ${ELIG_LOG}/${LOG_NAME}
echo "" >> ${ELIG_LOG}/${LOG_NAME}
ls -l gce${DATE}-X12 >> ${ELIG_LOG}/${LOG_NAME}
cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}


exit 0
