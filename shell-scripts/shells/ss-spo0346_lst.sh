#!/bin/ksh
#
# Program Name	: ss-spo0346.sh
#		  Command Line Arguments:
#		  -d <mmdd> - current date
# Description	: Moves and creates listing of the sys68/spo0346 eligibility file
# Author	: Linda S. Jefferis
# Date		: 02/22/2008
# Modifications : 11/11/2009 - Added ToPDMI sub-directory
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_ARCH="/usr/lnk/elig_in_1"
ELIG_LOG="/usr/lnk/elig_in/logs"
SYS_DIR="sys0068"
CLIENT="pl"
DATE="null"
REMOTE_DIR="/usr/lnk/wt/benes-wt/ToPDMI"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ss-spo0346.sh -d <mmdd>

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
	ELIG_FILE="C5?71813.TXT"
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
        mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
	if test $? -ne 0
	then
		echo "-*> Unable to access ${REMOTE_DIR}/${ELIG_FILE}..."
		echo "-*> Exiting the script."
		exit 1
	fi
        cp ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_ARCH}
}

#
# Create listing
create_listing()
{
        LOG_NAME=ss-spo0346-${DATE}.log
        cd ${ELIG_DIR}
        echo "SSI-Plumbers(sys68/spo0346) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE} >> ${ELIG_LOG}/${LOG_NAME}
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
