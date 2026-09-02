#!/bin/ksh
#
# Program Name	: sbm_lst.sh
# Description	: Creates log listing of Schnucks eligibility file.
#		  No input date, will use current mmdd.
# Author	: Linda S. Jefferis
# Date		: 12/10/2009
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
DATE=`date +%m%d`
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="sm"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: sbm_lst.sh

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
        PGP_FILE="schnucks_elig.txt.pgp"
	ELIG_FILE="schnucks_elig.txt"
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
	cp ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_ARCH}
}

#
# Create Listing
create_listing()
{
	LOG_NAME=${CLIENT}e-${DATE}.log
        cd ${ELIG_DIR}
        echo "Schnucks (spo0606) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "-------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE} >> ${ELIG_LOG}/${LOG_NAME}
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

set_filename

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
