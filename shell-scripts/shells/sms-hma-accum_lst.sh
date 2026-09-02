#!/bin/ksh
#
# Program Name	: sms-hma-accum_lst.sh
#		  Command Line Arguments:
#		  -d <ccyymmdd> - date on elig. file sent
# Description	: Moves and creates listing of the SMS-HMA(sys167/spo1341) accumulator file
# Author	: Linda Jefferis
# Date		: 09/22/2014
# Modifcations  : 
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_ARCH="/usr/lnk/elig_in_1"
ELIG_LOG="/usr/lnk/elig_in/logs"
SYS_DIR="sys0167"
CLIENT="ts"
INPUT_DATE="null"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
FTP_DIR="/usr/lnk/wt/hma-ftps/ToPDMI"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: sms-hma-accum_lst.sh -d <ccyymmdd>

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
# Convert the date
convert_date()
{
        DATE=`echo ${INPUT_DATE} | cut -c5-8`
}

#
# Set Filenames
set_filename()
{
	ACCUM_FILE="SMSTimesHMA_accum_${INPUT_DATE}.txt"
}


#
# Move files appropriately
move_files()
{
   if test -a ${FTP_DIR}/${ACCUM_FILE}
   then
        mv ${FTP_DIR}/${ACCUM_FILE} ${ELIG_DIR}/${CLIENT}l${DATE}
        cp ${ELIG_DIR}/${CLIENT}l${DATE} ${ELIG_ARCH}
   else
	echo "-*> The file, ${ACCUM_FILE}, does not exist."
   fi
}

#
# Create listing
create_listing()
{
        LOG_NAME=${CLIENT}l-${DATE}.log
        cd ${ELIG_DIR}
        echo "SMS-TimesHMA(sys167/spo1341) Accumulator File" > ${ELIG_LOG}/${LOG_NAME}
        echo "------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}l${DATE} >> ${ELIG_LOG}/${LOG_NAME}
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
