#!/bin/ksh
#
# Program Name	: clms_benov.sh
# Description	: Procedure to setup clmrt01 claims file for Benovations (sys0102)
#		  Command Line Arguments:
# Author	: Linda S. Jefferis
# Date		: 11/29/2011
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="????CLMRTBE"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
TR_DIR=/usr/lnk/shares/ftp-tmp
DATE=`date +%Y%m%d`
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_benov.sh 

ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="beno_pdmi_ch_${DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TR_DIR}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}



#
# Main routine
#


set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo "-=> Finished."

echo "-=> Upload file, ${TR_DIR}/${CLM_FILE}, to benovations@fd.changehealthcare.com using WinSCP on PGP10 server. Then forward the email notification."
echo "The file, ${CLM_FILE}, has been uploaded." | ${MAIL_PROG} -s "Benovations Bi-Monthly Claims File Notification" ${MAIL_TO}

exit 0
