#!/bin/ksh
#
# Program Name	: clms_lvhn.sh
# Description	: Procedure to provide cycle refresh file for LVHN (sys0162)
#		  Command Line Arguments:
#		  -p <ccyymmdd>  P/E date
# Author	: Linda S. Jefferis
# Date		: 12/10/2012
# Modifications : 02/05/2014 - updated MAIL_TO (TT #9032-9)
#		: 04/15/2014 - switch to clmrt01 format (TT #10237-3)
#		: 06/19/2014 - TT #11312-1 change request for notification.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="????CLMRTLV"
TEXT_FILE="????LVTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
ID="LVHN"
MAIL_PROG="/bin/mail"
MAIL_TO="spectrumadmin@lvhn.org LVHN@pdmi.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_lvhn.sh -p <p/e date>
	<p/e date> is period ending date in ccyymmdd format  (required)

ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="Refreshclms-LVHN-${PE_DATE}.txt"
	LOG_FILE="Refreshtotals-LVHN-${PE_DATE}.txt"
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
	   echo "The files for P/E ${PE_DATE} are now available. Please send confirmation email to LVHN@pdmi.com verifying the file was received and that there are no issues." | ${MAIL_PROG} -s "LVHN Refresh File Notification" -c ${MAIL_CC} ${MAIL_TO}
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
