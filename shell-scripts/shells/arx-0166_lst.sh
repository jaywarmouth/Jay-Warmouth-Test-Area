#!/bin/ksh
#
# Program Name	: arx-0166_lst.sh
# Description	: Creates log listing of Assist Rx (123) eligibility, accumulator, and exception files.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on elig. file sent.
# Author	: Linda S. Jefferis
# Date		: 01/06/2010
# Modifications : 02/19/2010 - Logic changes to handle auto archiving of the zero byte files that are sent and provide special message in listing.
#		: 03/03/2010 - Added REC_CNT logic
#               : 06/03/2013 - Removed zip_arch_elig.sh procedure (DME)
#               : 06/23/2015 - Updated accum filename
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
REMOTE_DIR="/usr/lnk/wt/arx2-ftps/ToPDMI"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
DATE="null"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="ax"
SYS="0166"
ELG=0
ACC=0
REC_CNT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: arx-0166_lst.sh [-d <ccyymmdd>]

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
	ELIG_FILE="ARXelig_${INPUT_DATE}.txt"
	ACC_FILE="ARXaccum_${INPUT_DATE}.txt"
}


#
# Move Files
move_files()
{
	### ELIG File
	if test -e ${REMOTE_DIR}/${ELIG_FILE}
	then
		if test -s ${REMOTE_DIR}/${ELIG_FILE}
		then
			ELG=1
			mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
        		cp ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_ARCH}
		else
			mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_ARCH}/sys${SYS}/${CLIENT}e${DATE}
		fi
	else
		echo "-*> Incorrect elig. filename..."
	fi

	### ACCUM File
	if test -e ${REMOTE_DIR}/${ACC_FILE}
	then
		if test -s ${REMOTE_DIR}/${ACC_FILE}
		then
			ACC=1
			mv ${REMOTE_DIR}/${ACC_FILE} ${ELIG_DIR}/${CLIENT}l${DATE}
			cp ${ELIG_DIR}/${CLIENT}l${DATE} ${ELIG_ARCH}
		else
			mv ${REMOTE_DIR}/${ACC_FILE} ${ELIG_ARCH}/sys${SYS}/${CLIENT}l${DATE}
		fi
	else
		echo "-*> Incorrect ACC filename..."
	fi

}

#
# Create Listing
create_listing()
{
	LOG_NAME=${CLIENT}-${DATE}.log
        cd ${ELIG_DIR}
        echo "AssistRx (SYS0166) Files" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
	if [ $ELG = 1 ]
	then
		ls -l ${CLIENT}e${DATE} >> ${ELIG_LOG}/${LOG_NAME}
		REC_CNT=`wc -l ${CLIENT}e${DATE} | awk '{print $1}'`
	else
		echo "${CLIENT}e${DATE} has zero records and no processing is needed" >> ${ELIG_LOG}/${LOG_NAME}
	fi
	if [ $ACC = 1 ]
	then
		ls -l ${CLIENT}l${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	else
		echo "${CLIENT}l${DATE} has zero records and no processing is needed" >> ${ELIG_LOG}/${LOG_NAME}
	fi
	echo "" >> ${ELIG_LOG}/${LOG_NAME}
	echo "Eligibility File Record Count is ${REC_CNT}" >> ${ELIG_LOG}/${LOG_NAME}
	echo "Operations please compare this total to count received in email from Assist Rx" >> ${ELIG_LOG}/${LOG_NAME}
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
