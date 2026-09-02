#!/bin/ksh
#
# Program Name	: prm_lst.sh
# Description	: Creates log listing of PRM eligibility file.
#                 Command Line Arguments:
#                 -d <mmdd> - date of file.
# Author	: Linda S. Jefferis
# Date		: 10/02/97
# Modifications : 08/25/98 Added logic for new PRMMEDEP file  (LSJ)
#		: 08/12/99 Added "Prmmedah" medical file  (LSJ)
#		: 08/12/99 Added logic for card counts  (LSJ)
#		: 08/31/99 Added logic to archive the medical files  (LSJ)
#		: 09/30/99 Added ps and hc medical file  (LSJ)
#		: 08/18/00 Added logic for dental cards  (LSJ)
#		: 08/28/00 logic for filename of "Pdmelig" or "pdmelig"  (LSJ)
#		: 09/29/00 Added dc medical file  (LSJ)
#		: 05/08/02 Incorporated the dental "dm" in with the medical procedure  (LSJ)
#		: 11/17/2003 - Changes for use of web transfer method  (LSJ)
#		: 01/15/2004 - Changes in unzip procedure to fix problem of files remianing out in the prm-wt folder. (LSJ)
#		: 05/16/2005 - Added conv_prmmed.sh procedure for medical files  (LSJ)
#               : 06/13/2005 - Changes for doing email of listing instead of printing for Benefits
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 05/31/2006 - Removed file day suffix logic, removed conv_prmmed.sh, and changed Medical file names  (LSJ)
#		: 07/12/2006 - Altered Medical file names  (LSJ)
#		: 07/27/2006 - Added logic to convert lower case medical file names to upper case.  (LSJ)
#		: 08/03/2006 - Changed where it archivies and removes prm.zip file  (LSJ)
#		: 08/14/2006 - Changed ELIG_FILE name to pdmelig.txt  (LSJ)
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#		: 11/11/2009 - Added ToPDMI sub-directory
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
DATE2=`date +%m%d%y`
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH=/usr/lnk/elig_in_1
SYS_DIR="sys0001"
PRM_TR=/usr/lnk/wt/prm-wt/ToPDMI
CARD_DIR="/usr/lnk/cards"
UNZIP_PROG="/usr/bin/unzip"
ZIP_FILE="prm.zip"
ELIG_FILE="pdmelig.asc"
MEDFILE[1]="MED-DC.TXT"
MEDFILE[2]="MED-DM.TXT"
MEDFILE[3]="MED-NS.TXT"
MEDFILE[4]="MED-PPI.TXT"
MEDFILE[5]="MED-PS.TXT"
MEDFILE[6]="MED-PSI.TXT"
MEDFILE[7]="MED-PSP.TXT"
MEDFILE[8]="MED-SS.TXT"
MAXVALUE=8
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
MED_MAIL_TO="operations@pdmi.com"
REMOTE_SYS=husk:/usr/lnk/shares/ftp-tmp

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: prm_lst.sh [-d <mmdd>] [-s <suffix>]

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
# Unzip files
unzip_file()
{
	if test -s ${PRM_TR}/${ZIP_FILE}
	then
	   ${UNZIP_PROG} -j -d ${ELIG_DIR} ${PRM_TR}/${ZIP_FILE}
	else
	   echo "${PRM_TR}/${ZIP_FILE} does not exist, process terminating..."
	   exit 1
	fi
}

# Medical files
medical_files()
{
   MED_LOG=prm-med${DATE}.log
   echo "PRM MEDICAL FILES FOR "${DATE2} > ${ELIG_LOG}/${MED_LOG}
   echo "-----------------------------" >> ${ELIG_LOG}/${MED_LOG}
   echo "" >> ${ELIG_LOG}/${MED_LOG}
   cd ${ELIG_DIR}
   for FILE in `ls MED-*.txt`
   do
	FILE_CAP=`echo $FILE | sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/'`
	mv $FILE $FILE_CAP
   done
   ls -l MED-*.TXT >> ${ELIG_LOG}/${MED_LOG}
   i=1
   while [ $i -le ${MAXVALUE} ]
   do
	if test -s ${ELIG_DIR}/${MEDFILE[i]}
	then
	   mv ${ELIG_DIR}/${MEDFILE[i]} ${CARD_DIR}/${MEDFILE[i]}
	   scp -q ${CARD_DIR}/${MEDFILE[i]} ${REMOTE_SYS}
	   MED_FILE=${CARD_DIR}/${MEDFILE[i]}
	   card_count
	   echo "" >> ${ELIG_LOG}/${MED_LOG}
	   echo "Number of Cards for ${MEDFILE[i]}:  ${TOTAL}" >> ${ELIG_LOG}/${MED_LOG}
	fi
	let i=i+1
   done
   cat ${ELIG_LOG}/${MED_LOG} | ${MAIL_PROG} -s "PRM Medical Files" ${MED_MAIL_TO}
}

# Card Count
card_count()
{
	TOTAL=`wc -l ${MED_FILE} | awk '{print $1}'`
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

if [ ${DATE} = "null" ]
then
   usage
fi

echo ""
echo "--=> Unzipping file.."
unzip_file

if test -a ${ELIG_DIR}/${ELIG_FILE}
then
   echo ""
   echo "--=> Moving and creating log report for the Elig. file."
   mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/pre${DATE}
   cp ${ELIG_DIR}/pre${DATE} ${ELIG_ARCH}
   LOG_NAME=prm${DATE}.log
   cd ${ELIG_DIR}
   echo "PRM Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
   echo "-------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
   echo "" >> ${ELIG_LOG}/${LOG_NAME}
   ls -l pre${DATE} >> ${ELIG_LOG}/${LOG_NAME}
   cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
fi
cp ${PRM_TR}/${ZIP_FILE} ${ELIG_ARCH}/${SYS_DIR}/prm${DATE}.zip
rm ${PRM_TR}/${ZIP_FILE}

echo ""
echo "--> Processing any medical file"

medical_files

exit 0
