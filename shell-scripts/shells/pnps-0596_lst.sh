#!/bin/sh
#
# Program Name	: pnps-0596_lst.sh
# Description	: Prepares eligibility file sent for Benefits and processing
#                 -d <yymmdd> - date on elig. file sent.
# Author	: Linda S. Jefferis
# Date		: 12/22/2009
# Modifications : Added -d option
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH="/usr/lnk/elig_in_1"
SYS_DIR="sys0122"
CLIENT_ID="cb"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
DATE=`date +%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pnps-0596_lst.sh 

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
	ELIG_FILE="${INPUT_DATE}??????h.x12"
	PGP_FILE="${INPUT_DATE}??????h.x12.pgp"
}

#
# Get file from remote system
get_file()
{
        scp ${REMOTE_SYS}:${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}
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
        if ! test -a ${ELIG_DIR}/${ELIG_FILE}
        then
          echo "-*> Incorrect elig. filename...exiting process"
          exit 1
        fi
        mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT_ID}e${DATE}-X12
        cp ${ELIG_DIR}/${CLIENT_ID}e${DATE}-X12 ${ELIG_ARCH}
}

#
# Create Listing
create_listing()
{
        LOG_NAME=${CLIENT_ID}e-spo0596-${DATE}.log
        cd ${ELIG_DIR}
        echo "PNPS - Cottingham and Butler (SPO0596) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "--------------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT_ID}e${DATE}-X12 >> ${ELIG_LOG}/${LOG_NAME}
        cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${ELIG_FILE}"
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
        ;;
  esac
  shift
done

if [ ${DATE} = "null" ]
then
   usage
fi


convert_date

set_filenames

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
