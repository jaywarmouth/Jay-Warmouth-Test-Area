#!/bin/ksh
#
# Program Name	: ault_lst.sh
# Description	: Creates log listing and moves Aultman eligibility, group, and physician files.
#		  Command line arguments:
#		  -d <yyyymmdd> - date for files
# Author	: Linda S. Jefferis
# Date		: 01/04/99
# Modifications : 04/09/99 - now move pdmpcp.txt(aup) file directly to sys048 archive directory until this file starts being used.  (LSJ)
#		  08/05/99 - aup will be used so changed where it gets moved (LSJ)
#		: 04/10/00 - changed aup procedure  (LSJ)
#		: 11/15/00 - changed pkunzip for new version  (LSJ)
#		: 11/27/00 - changed back to keep aup file  (LSJ)
#		: 02/16/2001 - Added UNZIP_PROG variable  (LSJ)
#		: 03/25/2002 - Changed HOME_TR for switch to WEB transfers  (LSJ)
#		: 03/29/2002 - changed /usr/lnk/transfers to /usr/lnk/wt  (LSJ)
#		: 05/09/2002 - Added logic for the .des file and possible alternate names that are sent for the zip file  (LSJ)
#		: 06/24/2002 - Added logic for limit file  (LSJ)
#		: 08/11/2004 - Addition of logic for full file flag  (LSJ)
#		: 04/28/2005 - Added logic to validate eligibility file  (LSJ)
#               : 06/13/2005 - Changes for doing email of listing instead of printing for Benefit  (LSJ)
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 01/10/2006 - Added logic for pdmoth.txt file  (LSJ)
#		: 02/28/2008 - changed pdmpcp.txt to pdmxprv.txt  (LSJ)
#		: 11/11/2009 - Added ToPDMI sub-directory
#		: 07/19/2017 - TT15567-33; date added to zip file name and removal of full file option.
#		: 07/19/2017 - also added logic to only handle PHYS file if it is found after unzip.
#
# Variables Used:
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_ARCH=/usr/lnk/elig_in_1
ELIG_LOG=/usr/lnk/elig_in/logs
HOME_TR=/usr/lnk/wt/ault-wt/ToPDMI
ELIG="pdmelg.txt"
GRP="pdmgrp.txt"
PHYS="pdmxprv.txt"
LIM="pdmacc.txt"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="au"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ault_lst.sh -d yyyymmdd 
	-d yyyymmdd 	enter date included in filename 	required

ENDOFUSAGE
  exit 99
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
        ZIP_FILE="pdm.full.${INPUT_DATE}.zip"
}

#
# Validation Check
validate_elig()
{
   echo "" >> ${ELIG_LOG}/${LOG_NAME}
   echo "VALIDATION COUNTS" >> ${ELIG_LOG}/${LOG_NAME}
   echo "-----------------" >> ${ELIG_LOG}/${LOG_NAME}
   BYTE_CNT=`wc -c ${ELIG_NAME} | awk '{print $1}'`
   REC_CNT=`expr $BYTE_CNT / 300`
   REMAINDER=`expr $BYTE_CNT % 300`
   if [ $REMAINDER -gt 0 ]
   then
      echo "The size of the eligibility file is not evenly divisible by the record size of 300"
      echo "Notify the Aultcare I.S. Dept. before processing, aultcare-is@aultman.com"
   else
      echo "ELIG BYTE COUNT = $BYTE_CNT     RECORD COUNT = BYTE COUNT/300 = $REC_CNT" >> ${ELIG_LOG}/${LOG_NAME}
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
        ;;
  esac
  shift
done

if [ ${INPUT_DATE} = "null" ]
then
   usage
fi

set_filename

if test -s ${HOME_TR}/${ZIP_FILE}
then
	${UNZIP_PROG} -juL -d ${ELIG_ARCH} ${HOME_TR}/${ZIP_FILE}
   	mv ${ELIG_ARCH}/${ELIG} ${ELIG_ARCH}/${CLIENT}e${DATE}-full
   	mv ${ELIG_ARCH}/${GRP} ${ELIG_ARCH}/${CLIENT}g${DATE}-full
   	mv ${ELIG_ARCH}/${LIM} ${ELIG_ARCH}/${CLIENT}l${DATE}-full
	if test -s ${ELIG_ARCH}/${PHYS}
	then
		mv ${ELIG_ARCH}/${PHYS} ${ELIG_ARCH}/${CLIENT}p${DATE}-full
	fi
else
	echo "-*> The file, ${HOME_TR}/${ZIP_FILE}, does not exist...exiting process"
	exit 99
fi

cp ${ELIG_ARCH}/${CLIENT}?${DATE}-full ${ELIG_DIR}
cp ${HOME_TR}/${ZIP_FILE} ${ELIG_ARCH}/sys0048
LOG_NAME=ault${DATE}-full.log
cd ${ELIG_DIR}
echo "Aultman Health Full Files" > ${ELIG_LOG}/${LOG_NAME}
echo "-------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
echo "" >> ${ELIG_LOG}/${LOG_NAME}
ls -l ${CLIENT}?${DATE}-full >> ${ELIG_LOG}/${LOG_NAME}
ELIG_NAME=${ELIG_DIR}/${CLIENT}e${DATE}-full
validate_elig
cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
rm ${HOME_TR}/${ZIP_FILE}

exit 0
