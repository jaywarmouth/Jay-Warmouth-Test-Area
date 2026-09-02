#!/bin/ksh
#
# Program Name	: clms_arx.sh
# Description	: Procedure to setup claims file for Assist Rx (sys0123)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 01/13/2010
# Modifications : 01/27/2010 - Added email notification
#		: 03/26/2010 - Removed zip logic
#		: 02/10/2012 - Changed ID from ARX to ARX2
#		: 12/21/2016 - TT13915-41: Update email notification address.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="????CLMRTAR"
TEXT_FILE="????ARTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
ID="ARX2"
MAIL_PROG="/bin/mail"
MAIL_TO="Nicole.Loper@assistrx.com Mitchell.Howell@Assistrx.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_arx.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="pdmi-clms-${PE_DATE}.txt"
	LOG_FILE="pdmi-text-${PE_DATE}.txt"
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
	   echo "The files for P/E ${PE_DATE} are now available." | ${MAIL_PROG} -s "ARX WEEKLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
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
