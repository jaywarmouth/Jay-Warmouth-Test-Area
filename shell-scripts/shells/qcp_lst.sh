#!/bin/ksh
#
# Program Name	: qcp_lst.sh
# Description	: Creates log listing of QCP/Anthem-Genesis eligibility files.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file sent 
# Author	: Linda S. Jefferis
# Date		: 07/13/2004
# Modifications : 07/15/2004 - Added archive of zip file  (LSJ)
#               : 06/13/2005 - Changes for doing email of listing instead of printing for Benefits
#		: 07/05/2005 - New filename and no zip  (LSJ)
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 12/03/2005 - Changes for new system names  (LSJ)
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
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
PREFIX=qce
SYS_DIR=sys0071
SHELL=/usr/lnk/shell
UNZIP_PROG="/usr/bin/unzip"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: qcp_lst.sh [-d <mmdd>]

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
        ELIG_FILE="PDMI${INPUT_DATE}.txt"
        PGP_FILE="PDMI${INPUT_DATE}.txt.pgp"
}

#
# Get file from remote system
get_file()
{
        scp ${REMOTE_SYS}:${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}
        if test $? -ne 0
        then
          echo "--*> RCP of file from ${REMOTE_SYS} failed"
          exit 1
        fi
}

#
# Move files appropriately
move_files()
{
        if ! test -a ${ELIG_DIR}/${ELIG_FILE}
        then
          echo "-*> Incorrect elig. filename...exiting process"
          exit 1
        fi
        mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/${PREFIX}${DATE}
        cp ${ELIG_DIR}/${PREFIX}${DATE} ${ELIG_ARCH}
}


#
# Create_listing
create_list()
{
	cd ${ELIG_DIR}
	LOG_NAME=qcp${DATE}.log
	echo "Quality Care Partners(QCP) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
	echo "--------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
	echo "" >> ${ELIG_LOG}/${LOG_NAME}
	ls -l ${PREFIX}${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	#lp ${ELIG_LOG}/${LOG_NAME}
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

if [ ${DATE} = "null" ]
then
   usage
fi

echo 
echo "--> Getting file"
get_file

echo
echo "--> Move file"
move_files

echo
echo "--> Creating log listing"
create_list

echo
echo "--> Doing cleanup"
cleanup

exit 0
