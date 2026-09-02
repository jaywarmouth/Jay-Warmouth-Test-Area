#!/bin/ksh
#
# Program Name	: mas_lst.sh
# Description	: Moves and creates listing of the Med. Admin. eligibility file
#                 Command Line Arguments:
#                 -d <mmdd> - date for files
# Author	: Linda S. Jefferis
# Date		: 04/24/2002
# Modifications : 02/18/2004 - Removed logic for the date input.  It now determones the date from the unzip text file name.  (LSJ)
#               : 06/13/2005 - Changes for doing email of listing instead of printing for Benefits
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 08/22/2006 - Changes for 4-digit system number  (LSJ)
#		: 10/13/2009 - Added logic back for date input  (LSJ)
#		: 11/11/2009 - Added ToPDMI sub-directory
#		: 11/17/2009 - Changed TXT_FILE
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_ARCH="/usr/lnk/elig_in_1"
ELIG_LOG="/usr/lnk/elig_in/logs"
SYS_DIR="sys0062"
INPUT_DATE="null"
ZIP_FILE="PDM.zip"
TXT_FILE=pdm*.txt
REMOTE_DIR="/usr/lnk/wt/mas-wt/ToPDMI"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mas_lst.sh -d <mmdd>
	where <mmdd> is current month and day

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
        DATE=$1
        ;;
  esac
  shift
done

#
# Move files appropriately
move_files()
{
        if test -a ${REMOTE_DIR}/${ZIP_FILE}
        then
	   ${UNZIP_PROG} -jLd ${ELIG_DIR} ${REMOTE_DIR}/${ZIP_FILE}
	   if test -s ${ELIG_DIR}/${TXT_FILE}
	   then
		mv ${ELIG_DIR}/${TXT_FILE} ${ELIG_DIR}/mae${DATE}
		cp ${ELIG_DIR}/mae${DATE} ${ELIG_ARCH}
	   else
	      echo "-*> ${TXT_FILE} is empty or does not exist"
	      echo "-*> Let supervisor know...script is exiting"
	      exit 1
	   fi
	   mv ${REMOTE_DIR}/${ZIP_FILE} ${ELIG_ARCH}/${SYS_DIR}/PDM${DATE}.zip
        else
           echo "${REMOTE_DIR}/${ZIP_FILE} file does not exist"
           exit 1
        fi
}

#
# Create listing
create_listing()
{
        LOG_NAME=mas-${DATE}.log
        cd ${ELIG_DIR}
        echo "Medical Admin Solutions Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "-----------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l mae${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}


# Parse environment variables
#parse_env

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

exit 0
