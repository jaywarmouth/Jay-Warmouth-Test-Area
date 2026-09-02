#!/bin/ksh
#
# Program Name	: wsn_elig_lst.sh
# Description	: Creates log listing of WSN (164) eligibility file.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on elig. file sent.
# Author	: Dawn M. Engler
# Date		: 3/12/2014
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL="/usr/lnk/shell"
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_ARCH=/usr/lnk/elig_in_1
ELIG_LOG=/usr/lnk/elig_in/logs
REMOTE_DIR="/usr/lnk/wt/wsn-wt/ToPDMI"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
DATE="null"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="wi"
SYS="0164"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: hometown_lst.sh [-d <ccyymmdd>]

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
	ELIG_FILE="WSN_elig_${INPUT_DATE}.txt"
}


#
# Move Files
move_files()
{
	if test -s ${REMOTE_DIR}/${ELIG_FILE}
	then
		mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
        	cp ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_ARCH}
	else
		echo "-*> Incorrect elig. filename...exiting process"
          	exit 1
	fi
}

#
# Create Listing
create_listing()
{
	LOG_NAME=${CLIENT}e-${DATE}.log
        cd ${ELIG_DIR}
        echo "WSN (sys0164) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "-------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
	ls -l ${CLIENT}e${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
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

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

exit 0
