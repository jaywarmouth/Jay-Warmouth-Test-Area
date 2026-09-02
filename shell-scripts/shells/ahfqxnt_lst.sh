#!/bin/ksh
#
# Program Name	: ahfqxnt_lst.sh
# Description	: Creates log listing and moves AHF-CommercialQXNT eligibility and other files.
#		  Command line arguments:
#		  -d <ccyymmdd> - date for files
# Author	: Linda S. Jefferis
# Date		: 11/14/2016
#               : 04/12/2017 - Updated SYS for "aq" to 0161  (LSJ)
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
REMOTE_DIR=/usr/lnk/wt/ault-wt/ToPDMI
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="aq"
SYS="0161"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ahfqxnt_lst.sh [-d <ccyymmdd>] 

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
	ZIP_FILE="ahfqxnt_${INPUT_DATE}.zip"
        ELIG_FILE="ahfqxnt_elig_${INPUT_DATE}.txt"
	GRP_FILE="ahfqxnt_grp_${INPUT_DATE}.txt"
	ACCUM_FILE="ahfqxnt_accum_${INPUT_DATE}.txt"
}

#
# Unzip and Move Files
move_files()
{
	if ! test -e ${REMOTE_DIR}/${ZIP_FILE}
	then
		echo "-*> Zip file, ${REMOTE_DIR}/${ZIP_FILE}, does not exist... exiting process"
		exit 1
	fi
	${UNZIP_PROG} -j -d ${ELIG_DIR} ${REMOTE_DIR}/${ZIP_FILE}
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
	if ! test -a ${ELIG_DIR}/${ACCUM_FILE}
	then
	  echo "-*> Incorrect accum filename..."
	fi
	mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
	mv ${ELIG_DIR}/${GRP_FILE} ${ELIG_DIR}/${CLIENT}g${DATE}
	mv ${ELIG_DIR}/${ACCUM_FILE} ${ELIG_DIR}/${CLIENT}l${DATE}
	mv ${REMOTE_DIR}/${ZIP_FILE} ${ELIG_ARCH}/sys${SYS}
	cp ${ELIG_DIR}/${CLIENT}?${DATE} ${ELIG_ARCH}
}

#
# Create Listing
create_listing()
{
        LOG_NAME=${CLIENT}e-${DATE}.log
        cd ${ELIG_DIR}
        echo "AHFCommercial-QXNT Eligibility Files" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}?${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	ELIG_NAME=${ELIG_DIR}/${CLIENT}e${DATE}
	validate_elig
        cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Validation Check
validate_elig()
{
   echo "" >> ${ELIG_LOG}/${LOG_NAME}
   echo "VALIDATION COUNTS" >> ${ELIG_LOG}/${LOG_NAME}
   echo "-----------------" >> ${ELIG_LOG}/${LOG_NAME}
   BYTE_CNT=`wc -c ${ELIG_NAME} | awk '{print $1}'`
   REC_CNT=`expr $BYTE_CNT / 302`
   REMAINDER=`expr $BYTE_CNT % 302`
   if [ $REMAINDER -gt 0 ]
   then
      echo "The size of the eligibility file is not evenly divisible by the record size of 302"
      echo "Notify the Aultcare I.S. Dept. before processing"
   else
      echo "ELIG BYTE COUNT = $BYTE_CNT     RECORD COUNT = BYTE COUNT/302 = $REC_CNT" >> ${ELIG_LOG}/${LOG_NAME}
   fi
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
echo "--> Move and unzip files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

exit 0
