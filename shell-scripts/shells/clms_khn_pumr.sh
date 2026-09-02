#!/bin/sh
#
# Program Name	: clms_khn_pumr.sh
# Description	: Procedure to setup claims file for KHN/PUMR and send to UMR
#		  Command Line Arguments:
#		  -p <mmddccyy>  
# Author	: Linda S. Jefferis
# Date		: 02/18/2019
# 
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
DEST_LOC=/usr/lnk/wt/oper-wt/sftpexport/UMR
TAPE_FILE="???CL109GRAN-T-KHN"
TEXT_FILE="???KHNTEXT"
PE_DATE="null"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="CustomerReportingRX@umr.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_khn_pumr.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


#
# Set filenames
set_filenames()
{
	CLM_FILE="MDSD53_P_Refreshclms-KHNPUMR-${PE_DATE}"
}

#
transfer_file()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  cp ${FILE_LOC}/${TAPE_FILE} ${DEST_LOC}/${CLM_FILE}
	  if test $? -eq 0
	  then
        	cat ${FILE_LOC}/${TEXT_FILE} | ${MAIL_PROG} -s "KHN-PUMR Refresh Claims File Notification" -c ${MAIL_CC} ${MAIL_TO}
	  else
        	echo "-*> File Transfer failed..."
	  fi
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
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
	set_filenames
	;;
  esac
  shift
done


if [ $PE_DATE = "null" ]
then
	usage
	exit 1
fi

echo
echo "--> Transfer file..."
echo

transfer_file

echo "-=> Finished."

exit 0
