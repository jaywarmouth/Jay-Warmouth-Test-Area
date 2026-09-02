#!/bin/sh
#
# Program Name	: clms_tsc_hcrm.sh
# Description	: Procedure to transfer claims data files to HCRM
#		  Command Line Arguments:
#		  -p <mmddccyy>  p/e date
# Author	: Linda S. Jefferis
# Date		: 07/08/2014
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
REMOTE_SYS=husk
TAPE_FILE="???CL109HCRM-W-HTSC"
MAIL_PROG="/usr/bin/mutt"
MAIL_CC="operations@pdmi.com"
MAIL_TO="cwydro@hcrmnet.net"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="300"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="HCRM"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_tsc_hcrm.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}

#
# Set Filenames
set_filenames()
{
	CLM_FILE="Weeklyclms-TSCHCRM-${PE_DATE}.txt"
}


#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
          ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  REC_CNT=`wc -l ${TMP_LOC}/${CLM_FILE} | awk '{ print $1 }'`
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
	   scp -q ${TMP_LOC}/${CLM_FILE} ${REMOTE_SYS}:${TMP_LOC}
	   ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE}"
	   if test $? -ne 0
	   then
		echo "*-> Transfer of file failed"
		clean_up
		exit 1
	   fi
	   echo -e "The TrueScripts data file for period ending ${PE_DATE}, has been uploaded.\n\nRecord Count = ${REC_CNT}" | ${MAIL_PROG} -s "TSC-HCRM File Notification" -c ${MAIL_CC} ${MAIL_TO}
	else
	   echo "--*> File not copied..."
	fi
}

#
# Cleanup
clean_up()
{
	ssh -q ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${TMP_LOC}/${CLM_FILE}"
	rm ${TMP_LOC}/${CLM_FILE}
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

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
