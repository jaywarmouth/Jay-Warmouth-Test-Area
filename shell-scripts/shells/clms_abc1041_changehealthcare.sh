#!/bin/ksh
#
# Program Name	: clms_abc1041_changehealthcare.sh
# Description	: Procedure to setup clmrt01 claims file for ABC-McKee (sys0075/spo1041)
#		  Command Line Arguments:
# Author	: Linda S. Jefferis
# Date		: 05/20/2014
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="????CLMRTMF"
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

usage: clms_abc1041_changehealthcare.sh 

ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="McKee_clms_${DATE}.txt"
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

echo "-=> Upload file, ${TR_DIR}/${CLM_FILE}, to pdmi@fd.changehealthcare.com using WinSCP on PGP10 server. Then forward the email notification to claimalert@changehealthcare.com."
echo "The file, ${CLM_FILE}, has been uploaded." | ${MAIL_PROG} -s "McKee Claims File Notification" ${MAIL_TO}

exit 0
