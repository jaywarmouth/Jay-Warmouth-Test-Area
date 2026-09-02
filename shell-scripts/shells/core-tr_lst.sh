#!/bin/ksh
#
# Program Name	: core-tr_lst.sh
# Description	: Creates log listing of AMS Coresource  eligibility file.
#                 Command Line Arguments:
#                 -d <mmdd> - date of file.
# Author	: Linda S. Jefferis
# Date		: 01/04/99
# Modifications : 08/04/99 - Added ELIG_ARCH variable and logic  (LSJ)
#		  08/30/99 - Added logic for zip file  (LSJ)
#		: 11/15/00 - Changed pkunzip for new version  (LSJ)
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
SYS_DIR="sys002"
HOME_TR=/home/ams/core-tr
ELIG_NAME="enrame.txt"
ZIP_FILE="ENRAME.zip"
ARCH_FILE="enrame"
UNZIP_PROG="/usr/local/bin/unzip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: core-tr_lst.sh [-d <mmdd>]

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
${UNZIP_PROG} -ju -d ${HOME_TR} ${HOME_TR}/${ZIP_FILE}
mv ${HOME_TR}/${ELIG_NAME} ${ELIG_DIR}/coe${DATE}
chmod 664 ${ELIG_DIR}/coe${DATE}
chgrp pdm ${ELIG_DIR}/coe${DATE}
cp ${HOME_TR}/${ZIP_FILE} ${ELIG_ARCH}/${SYS_DIR}/${ARCH_FILE}${DATE}.zip
cp ${ELIG_DIR}/coe${DATE} ${ELIG_ARCH}
LOG_NAME=core${DATE}.log
cd ${ELIG_DIR}
echo "AMS/Coresource Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
echo "-------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
echo "" >> ${ELIG_LOG}/${LOG_NAME}
ls -l coe${DATE} >> ${ELIG_LOG}/${LOG_NAME}
lpp ${ELIG_LOG}/${LOG_NAME}
rm ${HOME_TR}/${ZIP_FILE}


# Parse environment variables
#parse_env

exit 0
