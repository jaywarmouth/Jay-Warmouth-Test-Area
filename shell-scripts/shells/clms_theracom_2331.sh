#!/bin/ksh
#
# Program Name	: clms_theracom_2331.sh
# Description	: Procedure to provide cycle refresh file for TheraCom-Incivek (sys0152/spo2331)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 12/10/2012
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="???CL111D0-T-VTX"
TEXT_FILE="???CL111D0-T-VTXTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="500"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
ID="THC"
MAIL_PROG="/bin/mail"
MAIL_TO="datafeed.it@thera.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_theracom_2331.sh -p <p/e date>
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
	CLM_FILE="bimonthlyTHCIncivek-clms${FILE_DATE}.txt"
	LOG_FILE="bimonthlyTHCIncivek-totals${FILE_DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  cp ${FILE_LOC}/${TEXT_FILE} ${TMP_LOC}/${LOG_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}


#
# FTP file
ftp_file()
{
	if test -a ${TMP_LOC}/${CLM_FILE}
	then
	   ${TR_PROG} ${ID} ${TMP_LOC}/${CLM_FILE} ${TMP_LOC}/${LOG_FILE}
	   echo "The files for P/E ${PE_DATE} are now available." | ${MAIL_PROG} -s "TheraCom-Incivek Cycle Refresh File Notification" -c ${MAIL_CC} ${MAIL_TO}
	else
	   echo "--*> File not copied..."
	fi
}


#
# Cleanup
clean_up()
{
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
   exit 2
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
