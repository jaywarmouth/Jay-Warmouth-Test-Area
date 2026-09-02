#!/bin/ksh
#
# Program Name	: ag_lst.sh
# Description	: Creates log listing of AGMC eligibility file.
#                 Command Line Arguments:
#                 -d <mmdd> - date of files.
# Author	: Linda S. Jefferis
# Date		: 04/10/97
# Modifications : 09/08/97 (LSJ) changed elig. file name to mbe
#		  07/27/99 (LSJ) changed where pdmtfr.zip was being archived
#		: 02/12/01 (LSJ) Changed where the unzip puts the files; added -d option on the pkunzip
#		: 02/16/2001 (LSJ) Added UNZIP_PROG variable
#		: 03/29/2001 (LSJ) Changed home directory where files get put
#		: 01/07/2004 (LSJ) Change for file being Encrypted and FTP'ed to FTP server.
#               : 06/13/2005 - Changes for doing email of listing instead of printing for Benefits  (LSJ)
#		: 10/13/2005 - Changes for linux  (LSJ)
#		: 11/30/2005 - Changes for new system names  (LSJ)
#		: 07/03/2014 - Add logic and variable to run decrypt_file.sh (TT:10901-1)(DME)
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
SYS="sys052"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
FTP_DIR="/usr/lnk/wt/agh-ftp"
PGP_SCRPT="/usr/lnk/shell/decrypt_file.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ag_lst.sh [-d <mmdd>]

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
        PGP_FILE="ag233ext-pdm.gpg"
	ELIG_FILE="AG233EXT"
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
	mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/age${DATE}
	cp ${ELIG_DIR}/ag?${DATE} ${ELIG_ARCH}
}

#
# Create Listing
create_listing()
{
	LOG_NAME=ag${DATE}.log
        cd ${ELIG_DIR}
        echo "Akron General(sys52) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ag?${DATE} >> ${ELIG_LOG}/${LOG_NAME}
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
