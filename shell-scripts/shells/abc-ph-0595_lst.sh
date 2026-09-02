#!/bin/sh
#
# Program Name	: abc-ph-0595_lst.sh
# Description	: Prepares eligibility file sent from NGS for Benefits and processing
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file downloaded.
# Author	: Linda S. Jefferis
# Date		: 12/10/2009
# Modifications : 07/01/2014 - add logic and variables to run decrypt_file.sh (TT10901-1)(DME) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH="/usr/lnk/elig_in_1"
SYS_DIR="sys0075"
CLIENT_ID="ph"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
FTP_DIR="/usr/lnk/wt/ngs-ftp"
PGP_SCRPT="/usr/lnk/shell/decrypt_file.sh"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: abc-ph-0595_lst.sh -d <ccyymmdd>

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
        DATE=`echo ${INPUT_DATE} | cut -c5-8`
}


# Set Filenames
set_filenames()
{
	ELIG_FILE="NGS_23004_${INPUT_DATE}"
	PGP_FILE="NGS_23004_${INPUT_DATE}.pgp"
}

#
# Get file from remote system
get_file()
{
        scp ${FTP_DIR}/${PGP_FILE} ${REMOTE_SYS}:${REMOTE_DIR}
        if test $? -ne 0
        then
             echo "--*> SCP of ${PGP_FILE} failed"
             exit 1
        fi
        ${PGP_SCRPT} ${PGP_FILE}  ${ELIG_FILE}
        scp ${REMOTE_SYS}:${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}
        if test $? -ne 0
        then
          echo "--*> SCP of file from ${REMOTE_SYS} failed"
          exit 1
        fi
        rm -f ${FTP_DIR}/${PGP_FILE}
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
        LOG_NAME=${CLIENT_ID}e-spo0595-${DATE}.log
        cd ${ELIG_DIR}
        echo "ABC - Port Huron (SPO0595) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "----------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
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
        convert_date
	set_filenames
        ;;
  esac
  shift
done

if [ ${INPUT_DATE} = "null" ]
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
