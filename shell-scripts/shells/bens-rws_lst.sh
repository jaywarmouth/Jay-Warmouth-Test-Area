#!/bin/ksh
#
# Program Name	: bens-rws_lst.sh
#		  Command Line Arguments:
#		  -d <mmdd> - date on elig. file sent
# Description	: Moves and creates listing of the Ridgewood (sys79/spo0476) eligibility file
# Author	: Linda S. Jefferis
# Date		: 07/12/2006
# Modifications : 11/11/2009 - Added new ToPDMI directory
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_ARCH="/usr/lnk/elig_in_1"
ELIG_LOG="/usr/lnk/elig_in/logs"
SYS_DIR="sys079"
DATE="null"
REMOTE_DIR="/usr/lnk/wt/bens-wt/ToPDMI"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: bens-rws_lst.sh -d <mmdd>

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
	ELIG_FILE="RIDG${DATE}.TXT"
	if test -a ${REMOTE_DIR}/RIDG${DATE}.zip
	then
	   ZIP_FILE="RIDG${DATE}.zip"
	else 
	   if test -a ${REMOTE_DIR}/RIDG${DATE}.ZIP
	   then
		ZIP_FILE="RIDG${DATE}.ZIP"
	   else
		echo "${REMOTE_DIR}/RIDGE${DATE}.zip or ${REMOTE_DIR}/RIDGE${DATE}.ZIP do not exist"
		exit 1
	   fi
	fi	
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
	${UNZIP_PROG} -jd ${ELIG_DIR} ${REMOTE_DIR}/${ZIP_FILE}
	mv ${REMOTE_DIR}/${ZIP_FILE} ${ELIG_ARCH}/${SYS_DIR}
        mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/rwe${DATE}
        cp ${ELIG_DIR}/rwe${DATE} ${ELIG_ARCH}
}

#
# Create listing
create_listing()
{
        LOG_NAME=bens-rws${DATE}.log
        cd ${ELIG_DIR}
        echo "Ridgewood (sys79/spo0476) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "-------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l rwe${DATE} >> ${ELIG_LOG}/${LOG_NAME}
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
