#!/bin/sh
#
# Program Name	: clms_onth.sh
# Description	: Procedure to setup claims file for Origins Hospice (sys0125)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 11/25/2009
# Modifications : 03/19/2010 - Removed zip of files as per request from OPS 
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
DEST_LOC=/usr/lnk/wt/oper-wt/sftpexport/ONTH
TAPE_FILE="????CLMRTOH"
TEXT_FILE="????OHTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_onth.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="pdm-${PE_DATE}.txt"
	LOG_FILE="pdm-text-${PE_DATE}.txt"
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
# Transfer file
transfer_file()
{
	mv ${TMP_LOC}/${CLM_FILE} ${DEST_LOC}
	cp ${FILE_LOC}/${TEXT_FILE} ${DEST_LOC}/${LOG_FILE}
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
