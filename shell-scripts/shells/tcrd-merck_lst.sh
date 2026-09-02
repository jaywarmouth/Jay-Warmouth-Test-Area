#!/bin/ksh
#
# Program Name	: tcrd-merck_lst.sh
# Description	: Creates log listing of TCRD Merck Pharmacy file.
#                 Command Line Arguments:
#                 -d <mmdd> - date of files.
# Author	: Linda S. Jefferis
# Date		: 11/17/2005
# Modifications : 12/03/2005 - Changes for new system names  (LSj)
#		: 03/14/2006 - Addition of "umask 002"  (LSJ)
#		: 03/15/2006 - Changed "umask 002" to "umask 000"  (LSJ)
#		: 03/17/2006 - Removed umask command and added chmod  (LSJ)
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_ARCH=/usr/lnk/elig_in_1
ELIG_LOG=/usr/lnk/elig_in/logs
REMOTE_DIR="/usr/lnk/shares/ftp-tmp/TCRD-Merck-Pharmacy"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
SYS="sys0078"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
#MAIL_TO="ljefferis@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tcrd-merck_lst.sh [-d <mmdd>]

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
	ELIG_FILE="MERCK_pharmacy_exclude.txt"
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
	mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/merck${DATE}
	chmod 666 ${ELIG_DIR}/merck${DATE}
	cp ${ELIG_DIR}/merck${DATE} ${ELIG_ARCH}/${SYS}
}

#
# Create Listing
create_listing()
{
	LOG_NAME=tcrd-merck${DATE}.log
        cd ${ELIG_DIR}
        echo "TCRD (sys78) Merck Pharmacy File" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l merck${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${ELIG_FILE}"
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
        DATE=$1
	set_filename
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
