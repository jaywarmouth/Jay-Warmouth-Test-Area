#!/bin/ksh
#
# Program Name	: mbi-wgh_lst.sh
# Description	: Creates log listing of MBI-Wabash (68-525) Eligibility file.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file sent.
# Author	: Linda S. Jefferis
# Date		: 1/3/2008
# Modifications : 
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
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
SHELL="/usr/lnk/shell"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com computers@pdmi.com"
CLIENT="wm"
SYS="0068"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mbi-wgh_lst.sh [-d <ccyymmdd>]

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
        PGP_FILE="146-${INPUT_DATE}.pgp"
	ELIG_FILE="146-${INPUT_DATE}.exp"
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
	mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
	chmod 770 ${ELIG_DIR}/${CLIENT}e${DATE}
	chgrp pdm ${ELIG_DIR}/${CLIENT}e${DATE}
}

#
# Create Listing
create_listing()
{
	LOG_NAME=mbi-wgh${DATE}.log
        cd ${ELIG_DIR}
        echo "MBI-Wabash(68-525) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
	cp ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_ARCH}/sys${SYS}
	${SHELL}/zip_arch_elig.sh -t elig -c ${CLIENT} -d ${DATE} -s ${SYS} -e 0
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
