#!/bin/ksh
#
# Program Name	: mbm-mbenelig_lst.sh
# Description	: Creates log listing of MBM eligibility file.
#                 unzips pdmtfr.zip and moves it to elig_in/mbm<mmdd>
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
#               : 06/13/2005 - Changes for doing email of listing instead of printing for Benefits
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 12/03/2005 - Changes for new system names  (LSJ)
#		: 07/03/2006 - Addition of accumulator file, mbl  (LSJ)
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#		: 02/20/2007 - Addition of pdmlimt.txt file  (LSJ)
#		: 06/25/2014 - add variables and coding to run decrypt_file.sh (TT:10901-1)(DME)
#		: 04/18/2023 - remove decryption steps and modify name due to SFTP changes (DME)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_ARCH=/usr/lnk/elig_in_1
ELIG_LOG=/usr/lnk/elig_in/logs
REMOTE_DIR="/usr/lnk/wt/oper-wt/elig/MBEN/ToPDMI"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mbm-mbenelig_lst.sh [-d <mmdd>]

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
	ZIP_FILE="MEDBEN.${INPUT_DATE}.zip"
	ELIG_FILE="pdmdoc.txt"
	GRP_FILE="pdmgdoc.txt"
	ACCUM_FILE="pdmlimt.txt"
	OTH_FILE="pdmadoc.txt"
}

#
# Get file from remote system
get_file()
{
        if ! test -a ${REMOTE_DIR}/${ZIP_FILE}
	 then
          echo "-*> Incorrect elig. filename...exiting process"
          exit 1
	else
	  mv ${REMOTE_DIR}/${ZIP_FILE} ${ELIG_DIR}/${ZIP_FILE}
        fi
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
	mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/mbe${DATE}
	mv ${ELIG_DIR}/${GRP_FILE} ${ELIG_DIR}/mbg${DATE}
	mv ${ELIG_DIR}/${ACCUM_FILE} ${ELIG_DIR}/mbl${DATE}
	cp ${ELIG_DIR}/mb?${DATE} ${ELIG_ARCH}
	mv ${ELIG_DIR}/${ZIP_FILE} ${ELIG_ARCH}/${SYS}/${ZIP_FILE}
	rm -f ${ELIG_DIR}/${OTH_FILE}
}

#
# Create Listing
create_listing()
{
	LOG_NAME=mbm${DATE}.log
        cd ${ELIG_DIR}
        echo "MBM(sys49) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l mb?${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${ZIP_FILE}"
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

echo "--> Copy file from ${REMOTE_DIR}"
get_file

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

echo
echo "--> Doing cleanup"
#cleanup

exit 0
