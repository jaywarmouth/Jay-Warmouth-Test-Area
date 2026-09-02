#!/bin/ksh
#
# Program Name	: psg-1252phys_lst.sh
# Description	: Moves files and creates log listing of PSG-1252 physician file.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file sent.
# Author	: Linda S. Jefferis
# Date		: 02/27/2014
# Modifications : 07/03/2014 - Add logic and variables to run decrypt_file.sh (TT:10901-1)(DME)
#
#
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
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="mr"
FTP_DIR="/usr/lnk/wt/psg-ftp/ToPDMI"
PGP_SCRPT="/usr/lnk/shell/decrypt_file.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: psg-1252phys_lst.sh [-d <ccyymmdd>]

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

#
# Set Filenames
set_filename()
{
	PHYS_FILE="PSG-McAlester-phys-${INPUT_DATE}.TXT"
	PHYS_PGP_FILE="PSG-McAlester-phys-${INPUT_DATE}.TXT.pgp"
}

#
# Get file from remote system
get_file()
{
        scp ${FTP_DIR}/${PHYS_PGP_FILE} ${REMOTE_SYS}:${REMOTE_DIR}
        if test $? -ne 0
        then
             echo "--*> SCP of ${PHYS_PGP_FILE} failed"
             exit 1
        fi
        ${PGP_SCRPT} ${PHYS_PGP_FILE}  ${PHYS_FILE}
        scp ${REMOTE_SYS}:${REMOTE_DIR}/${PHYS_FILE} ${ELIG_DIR}
        if test $? -ne 0
        then
          echo "--*> SCP of file from ${REMOTE_SYS} failed"
          exit 1
        fi
        rm -f ${FTP_DIR}/${PHYS_PGP_FILE}
}

#
# Move Files
move_files()
{
        if ! test -a ${ELIG_DIR}/${PHYS_FILE}
        then
          echo "-*> Incorrect elig. filename...exiting process"
          exit 1
	else
          mv ${ELIG_DIR}/${PHYS_FILE} ${ELIG_DIR}/${CLIENT}p${DATE}
          cp ${ELIG_DIR}/${CLIENT}p${DATE} ${ELIG_ARCH}
        fi
}

#
# Create Listing
create_listing()
{
        LOG_NAME=${CLIENT}p-${DATE}.log
        cd ${ELIG_DIR}
        echo "PSG-1252 Physician Files" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}p${DATE} >> ${ELIG_LOG}/${LOG_NAME}
        cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${PHYS_FILE}"
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${PHYS_PGP_FILE}"
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
