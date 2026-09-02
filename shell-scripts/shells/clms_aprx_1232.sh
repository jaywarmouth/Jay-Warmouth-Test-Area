#!/bin/sh
#
# Program Name	: clms_aprx_1232.sh
# Description	: Procedure to transfer claims data files to APRX
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 07/18/2013
#

# Variables Used:
FILE_LOC="/usr/lnk/tapes"
DEST_LOC=/usr/lnk/wt/aprx-wt/FromPDMI
TMP_LOC="/tmp"
TAPE_FILE="???CL111D0-T-CDB"
LOG_FILE="???CL111D0-T-CDBTEXT"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="kdurham@customdesignbenefits.com"
MAIL_CC="operations@pdmi.com"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="500"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_aprx_1232.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="aprxcdb-clms-${PE_DATE}.txt"
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
# Transfer files
transfer_file()
{
	if test -f ${TMP_LOC}/${CLM_FILE}
	then
	   mv ${TMP_LOC}/${CLM_FILE} ${DEST_LOC}
	   if test $? -ne 0
	   then
		echo "*-> Transfer of file failed"
	   fi
	   cat ${FILE_LOC}/${LOG_FILE} | ${MAIL_PROG} -s "APRX-CDB Claims File Notification" -c ${MAIL_CC} ${MAIL_TO}
	else
	   echo "--*> File not copied..."
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
echo "--> Transferring file..."
echo

transfer_file

echo "-=> Finished."

exit 0
