#!/bin/sh
#
# Program Name	: clms_theracom_2332.sh
# Description	: Procedure to provide cycle refresh file for TheraCom-Ampyra (sys0152/spo2332)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 12/10/2012
# Modifications	: 9/1/2015 - TT:13915-8 - updated Incivek references to Ampyra
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL111D0-T-ACR"
TEXT_FILE="???CL111D0-T-ACRTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="500"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
ID="THC"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="datafeed.it@thera.com"
MAIL_CC="operations@pdmi.com"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_theracom_2332.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	MON=`echo ${PE_DATE} | cut -c1-2`
	DAY=`echo ${PE_DATE} | cut -c3-4` 
	YR=`echo ${PE_DATE} | cut -c5-8`
	FILE_DATE=${YR}${MON}${DAY}
	CLM_FILE="bimonthlyTHCAmpyra-clms${FILE_DATE}.txt"
	LOG_FILE="bimonthlyTHCAmpyra-totals${FILE_DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  scp ${TMP_LOC}/${CLM_FILE} ${REMOTE_SYS}:${TMP_LOC}
	  scp ${FILE_LOC}/${TEXT_FILE} ${REMOTE_SYS}:${TMP_LOC}/${LOG_FILE}
	else
	  echo "*-> Claims file does not exist..."
	  exit 1
	fi
}


#
# FTP file
ftp_file()
{
	ssh ${REMOTE_SYS} "${TR_PROG} ${ID} ${TMP_LOC}/${CLM_FILE} ${TMP_LOC}/${LOG_FILE}"
	if test $? -eq 0
	then
	   echo "The files for P/E ${PE_DATE} are now available." | ${MAIL_PROG} -s "TheraCom-Ampyra Cycle Refresh File Notification" -c ${MAIL_CC} ${MAIL_TO}
	else
	   echo "*-> Transfer of file failed"
	   cleanup
	fi
}


#
# Cleanup
clean_up()
{
	ssh -q ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${TMP_LOC}/${CLM_FILE}"
	ssh -q ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${TMP_LOC}/${LOG_FILE}"
	rm -f ${TMP_LOC}/${CLM_FILE}
	rm -f ${TMP_LOC}/${LOG_FILE}
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 99
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	PE_DATE=$1
	;;
  esac
  shift
done


set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo 
echo "--> Transferring file to ${ID}..."
echo

ftp_file

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
