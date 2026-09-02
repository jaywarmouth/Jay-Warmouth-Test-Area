#!/bin/sh
#
# Program Name	: pmsi_pharm_lst.sh
# Description	: Prepares pharmacy file sent from PMSI for Benefits and processing
#                 Command Line Arguments:
#                 -d <yymmdd> - date on file uploaded.
#		  -t Flag for send type of test
# Author	: Linda S. Jefferis
# Date		: 03/24/2008
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
PHARM_DIR=/usr/lnk/elig_in
LOG_DIR=/usr/lnk/elig_in/logs
ARCH_DIR="/usr/lnk/elig_in_1"
CLIENT_ID="ps"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="pharmacy@pdmi.com mpaulus@pdmi.com operations@pdmi.com"
SEND_TYPE="prod"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pmsi_pharm_lst.sh -d <yymmdd>

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
# Convert the date
convert_date()
{
        DATE=`echo ${INPUT_DATE} | cut -c3-6`
}


# Set Filenames
set_filenames()
{
	PHARM_FILE="phnetw_${SEND_TYPE}_${INPUT_DATE}??????.dat"
	PGP_FILE="phnetw_${SEND_TYPE}_${INPUT_DATE}??????.dat.pgp"
}

#
# Get file from remote system
get_file()
{
        scp ${REMOTE_SYS}:${REMOTE_DIR}/${PHARM_FILE} ${PHARM_DIR}
        if test $? -ne 0
        then
          echo "--*> SCP of file from ${REMOTE_SYS} failed"
          exit 1
        fi
}

#
# Move Files
move_files()
{
        if ! test -a ${PHARM_DIR}/${PHARM_FILE}
        then
          echo "-*> Incorrect pharmacy filename...exiting process"
          exit 1
        fi
        mv ${PHARM_DIR}/${PHARM_FILE} ${PHARM_DIR}/${CLIENT_ID}n${DATE}
        cp ${PHARM_DIR}/${CLIENT_ID}n${DATE} ${ARCH_DIR}
}

#
# Create Listing
create_listing()
{
        LOG_NAME=${CLIENT_ID}n${DATE}.log
        cd ${PHARM_DIR}
        echo "PMSI (sys0103) Pharmacy File" > ${LOG_DIR}/${LOG_NAME}
        echo "-----------------------------" >> ${LOG_DIR}/${LOG_NAME}
        echo "" >> ${LOG_DIR}/${LOG_NAME}
        ls -l ${CLIENT_ID}n${DATE} >> ${LOG_DIR}/${LOG_NAME}
        cat ${LOG_DIR}/${LOG_NAME} | ${MAIL_PROG} -s "PMSI DAILY PHARMACY" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${PHARM_FILE}"
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${PGP_FILE}"
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
	set_filenames
        ;;
    -t) SEND_TYPE="test"
	;;
  esac
  shift
done

if [ ${DATE} = "null" ]
then
   usage
fi

echo "--> SCP file from ${REMOTE_SYS}"
get_file

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

echo
echo "--> Doing cleanup"
cleanup


exit 0
