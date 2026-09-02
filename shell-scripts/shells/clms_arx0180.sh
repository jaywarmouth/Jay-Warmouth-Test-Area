#!/bin/ksh
#
# Program Name	: clms_arx0180.sh
# Description	: Procedure to setup claims file for Assist Rx (sys0180)
#			TT:16314-12
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 12/22/2016
# Modifications	: 01/19/2017 - TT13915-42 update MAIL_To
#		: 03/14/2017 - TT16626-11; update distribution location
#		: 03/28/2017 - TT16626-12; update MAIL_TO
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="????CLMRTRP"
LOG_FILE="????RPTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
ID="ARX180"
MAIL_PROG="/bin/mail"
MAIL_TO="PrimeSCS@assistrx.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_arx0180.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


#
# Convert input date
conv_date()
{
	MO=`echo ${IN_DATE} | cut -c1-2`
        DAY=`echo ${IN_DATE} | cut -c3-4`
        YR=`echo ${IN_DATE} | cut -c5-8`
        PE_DATE=${YR}${MO}${DAY}
}

#
# Set Filenames
set_filenames()
{
	CLM_FILE="Refreshclms-ARXARP-${PE_DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
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
	   ${TR_PROG} ${ID} ${TMP_LOC}/${CLM_FILE} 
	   cat ${FILE_LOC}/${LOG_FILE} | ${MAIL_PROG} -s "ARX-ARP0180 Refresh Claims File Notification" -c ${MAIL_CC} ${MAIL_TO}
	else
	   echo "--*> File not copied..."
	fi
}


#
# Cleanup
clean_up()
{
	rm -f ${TMP_LOC}/${CLM_FILE}
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
	IN_DATE=$1
	conv_date
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
