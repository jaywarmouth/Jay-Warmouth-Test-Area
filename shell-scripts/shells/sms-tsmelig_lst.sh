#!/bin/sh
#
# Program Name	: sms-tsmelig_lst.sh
# Description	: Creates log listing of Synergy MedSolutions eligibility file.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date in file sent.
# Author	: Linda S. Jefferis
# Date		: 05/15/2014
# Modifications : 06/30/2014 - add logic and variables to run decrypt_file.sh (TT:10901-1)(DME)
#		: 03/04/2019 - Remove Decryption process and modify the REMOTE_DIR (TT:19502-2; DME)
#		: 03/13/2019 - New script; Change XLS to X12 (TT #19502-4)
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_ARCH=/usr/lnk/elig_in_1
ELIG_LOG=/usr/lnk/elig_in/logs
REMOTE_DIR="/usr/lnk/wt/oper-wt/elig/SMSTIMES"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
SYS="sys0167"
MAIL_PROG="/bin/mail"
MAIL_TO="elig_accum@pdmi.com operations@pdmi.com"
CLIENT="ts"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: sms-tsmelig_lst.sh [-d <ccyymmdd>]

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
# Set Filenames
set_filename()
{
	ELIG_FILE="TimesSupermarket_Elig_${INPUT_DATE}"
}

#
# convert date
convert_date()
{
	DATE=`echo ${INPUT_DATE} | cut -c5-8`
}


#
# Move Files
move_files()
{
	if ! test -a ${REMOTE_DIR}/${ELIG_FILE}
	then
	  echo "-*> Incorrect elig. filename...exiting process"
	  exit 1
	fi
	mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}-X12
	cp ${ELIG_DIR}/${CLIENT}e${DATE}-X12 ${ELIG_ARCH}
}

#
# Create Listing
create_listing()
{
	LOG_NAME=${CLIENT}e-${DATE}.log
        cd ${ELIG_DIR}
        echo "SMS-TimesSupermarket(1341) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE}-X12 >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INPUT_DATE=$1
	convert_date
	set_filename
        ;;
  esac
  shift
done

if [ ${INPUT_DATE} = "null" ]
then
   usage
fi

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

exit 0
