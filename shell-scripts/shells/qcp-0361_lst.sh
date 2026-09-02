#!/bin/ksh
#
# Program Name	: qcp-0361_lst.sh
# Description	: Creates log listing of QCP-spo0361 eligibility and group files.
#                 Command Line Arguments:
#                 -d <mmdd> - date of files.
# Author	: Linda S. Jefferis
# Date		: 12/27/2013
# Modifications	: 06/25/2014 - add coding and variables to run decrypt_file.sh (TT:10901-1)(DME)
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
SYS="sys0071"
CLIENT="gh"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
FTP_DIR="/usr/lnk/wt/hrmb-ftp"
PGP_SCRPT="/usr/lnk/shell/decrypt_file.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: qcp-0361_lst.sh [-d <mmdd>]

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
        PGP_FILE="QCPtfr.zip.pgp"
	ZIP_FILE="QCPtfr.zip"
	ELIG_FILE="qcpdoc.txt"
	GRP_FILE="qcpgdoc.txt"
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
        ${PGP_SCRPT} ${PGP_FILE}  ${ZIP_FILE}
        scp ${REMOTE_SYS}:${REMOTE_DIR}/${ZIP_FILE} ${ELIG_DIR}
        if test $? -ne 0
        then
          echo "--*> RCP of file from ${REMOTE_SYS} failed"
          exit 1
        fi
        rm -f ${FTP_DIR}/${PGP_FILE}
}

#
# Unzip and Move Files
move_files()
{
	${UNZIP_PROG} -jL -d ${ELIG_DIR} ${ELIG_DIR}/${ZIP_FILE}
	if ! test -a ${ELIG_DIR}/${ELIG_FILE}
	then
	  echo "-*> Incorrect elig. filename...exiting process"
	  exit 1
	fi
	if ! test -a ${ELIG_DIR}/${GRP_FILE}
	then
	  echo "-*> Incorrect elig. filename...exiting process"
	  exit 1
	fi
	mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
	mv ${ELIG_DIR}/${GRP_FILE} ${ELIG_DIR}/${CLIENT}g${DATE}
	cp ${ELIG_DIR}/${CLIENT}?${DATE} ${ELIG_ARCH}
}

#
# Create Listing
create_listing()
{
	LOG_NAME=${CLIENT}-${DATE}.log
        cd ${ELIG_DIR}
        echo "QCP-Genesis (71-361) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "----------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}?${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
	rm -f ${ELIG_DIR}/${ZIP_FILE}
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${ZIP_FILE}"
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

echo "--> RCP file from ${REMOTE_SYS}"
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
