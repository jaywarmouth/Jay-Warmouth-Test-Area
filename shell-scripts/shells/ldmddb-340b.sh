#!/bin/sh
#
# Program Name	: ldmddb-340b.sh
# Description   : Distribute 340b related Medispan files
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on zip filename.
# Author	: Linda S. Jefferis
# Date		: 12/09/2015
#		: 06/22/2016 - Added the logic for new 340b\Medispan folder (LSJ)
#
# Variables Used:
CURR_DATE=`date +%m/%d/%Y`
LOG="/tmp/medispan-340b.log"
TAPE_PATH="/usr/lnk/shares/ftp-tmp"
SQL_PATH="/usr/lnk/wt/sqlimports/340b/Medispan"
SQL_PATH2="/usr/lnk/wt/sqlimports/misc"
MAIL_PROG="/bin/mail"
MAIL_SUBJ="Weekly 340b Medispan"
MAIL_TO="MicrosoftDevelopmentTeam@pdmi.com operations@pdmi.com"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ldmddb-340b.sh 

ENDOFUSAGE
  exit 1
}

#
# Set Filenames
set_filenames()
{
	FILE1="icd10cmmc_0_0_wk_pdu-delimt_1.0_d_${DATE}.zip"
	FILE2="med-cond_0_0_wk_pdu-w-opt_1.0_d_${DATE}.zip"
	FILE3="indication_0_0_wk_pdu-std_1.0_d_${DATE}.zip"
	FILE4="mddbv2.5_0_0_wk_w-gppc_2.5_u_${DATE}.zip"
}


#
# Move files 
put_files()
{
	echo ""
	echo "--> Moving Files"
	cp ${TAPE_PATH}/${FILE1} ${SQL_PATH}
	cp ${TAPE_PATH}/${FILE2} ${SQL_PATH}
	cp ${TAPE_PATH}/${FILE3} ${SQL_PATH}
	cp ${TAPE_PATH}/${FILE4} ${SQL_PATH2}
}


# Send Notification 
send_email()
{
	echo "" > ${LOG}
	echo "The following file is available in clientfiles\sqlimports\misc:" >> ${LOG}
	cd ${SQL_PATH2}
	echo "`ls -l ${FILE4}`" >> ${LOG}
	echo "" >> ${LOG}
	echo "The following files are available in clientfiles\sqlimports\340b\Medispan:" >> ${LOG}
	cd ${SQL_PATH}
	echo "`ls -l ${FILE1}`" >> ${LOG}
	echo "`ls -l ${FILE2}`" >> ${LOG}
	echo "`ls -l ${FILE3}`" >> ${LOG}
	cat ${LOG} | ${MAIL_PROG} -s "${MAIL_SUBJ}" ${MAIL_TO}
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
	set_filenames
        ;;
  esac
  shift
done


date

put_files

send_email

date

exit 0
