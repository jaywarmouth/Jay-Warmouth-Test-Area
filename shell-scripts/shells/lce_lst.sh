#!/bin/ksh
#
# Program Name	: lce_lst.sh
#		  Command Line Arguments:
#		  -d <mmdd> - current date
# Description	: Moves and creates listing of the Special Lash Copay(sys120) eligibility file
# Author	: Linda S. Jefferis
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_ARCH="/usr/lnk/elig_in_1"
ELIG_LOG="/usr/lnk/elig_in/logs"
SYS_DIR="sys0120"
DATE="null"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="lc"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: lce_lst.sh -d <mmdd>

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
	ELIG_FILE="PDMI-Manual-Eligibility-*.csv"
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


#
# Move files appropriately
move_files()
{
	scp ${REMOTE_SYS}:${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}-XLS
	if test $? -ne 0
        then
          echo "--*> SCP of file from ${REMOTE_SYS} failed"
          exit 1
        fi
	cp ${ELIG_DIR}/${CLIENT}e${DATE}-XLS ${ELIG_ARCH}
}

#
# Create listing
create_listing()
{
        LOG_NAME=lce-${DATE}.log
        cd ${ELIG_DIR}
        echo "Lash Copay (sys0120) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "-------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE}-XLS >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${ELIG_FILE}"
}


# Parse environment variables
#parse_env

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
