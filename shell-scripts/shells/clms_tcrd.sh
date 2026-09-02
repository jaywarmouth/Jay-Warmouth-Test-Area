#!/bin/sh
#
# Program Name	: clms_trcd.sh
# Description	: Procedure to setup claims file for Soveirn Solutions
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 02/02/2005
# Modifications : 02/25/2005 - Switch to claim178 files  (LSJ) 
#		: 06/20/2005 - Changed wt location for files  (LSJ)
#		: 06/20/2005 - No longer zip files  (LSJ)
#		: 10/06/2005 - New tape file name  (LSJ)
#		: 10/20/2005 - Changes for linux  (LSJ)
#		: 10/24/2005 - Added addlf procedure  (LSJ)
#		: 11/07/2005 - Removed log file  (LSJ)
#		: 11/27/2005 - Changed system name  (LSJ)
#               : 02/14/2006 - Change /usr/bin/logname to computers@pdmi.com
#		: 05/02/2006 - Changed record size from 831 to 1024  (LSJ)
#		: 08/22/2007 - Switched from web transfer to FTP  (LSJ)
#		: 08/24/2007 - Added inv file to zip file  (LSJ)
#		: 12/21/2011 - Add TEXT_FILE and error check on zip and addlf processes
#		: 12/21/2011 - Changed date format on file names sent
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/usr/lnk/tmp"
TAPE_FILE="????CLMRTTRCD"
TEXT_FILE="????TRCDTEXT"
INV_LOC="/usr/lnk/xp/sys0078"
ZIP_PROG="/usr/bin/zip"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
ZIP_PROG="/usr/bin/zip"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="MERCALIS"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_trcd.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


#
# Split out p/e date
conv_date()
{
	MON=`echo ${PE_DATE} | cut -c1-2`
	DAY=`echo ${PE_DATE} | cut -c3-4`
	YEAR=`echo ${PE_DATE} | cut -c5-8`
}

#
# Set Filenames
set_filenames()
{
	CLM_FILE="pdm${YEAR}${MON}${DAY}.txt"
	LOG_FILE="totals${YEAR}${MON}${DAY}.txt"
	ZIP_FILE="pdm${YEAR}${MON}${DAY}.zip"
	INV_FILE="inv-t-${MON}${DAY}"
      	NEW_INV_FILE=78inv${YEAR}${MON}${DAY}.txt
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  if test $? -ne 0
	  then
		echo "-*> The addlf process failed. Cleaning up file and existing."
		echo "-*> Check reason for failure."
		rm -f ${TMP_LOC}/${CLM_FILE}
		exit 2
	  fi
	  cp ${FILE_LOC}/${TEXT_FILE} ${TMP_LOC}/${LOG_FILE}
	  ${ZIP_PROG} -jm ${TMP_LOC}/${ZIP_FILE} ${TMP_LOC}/${CLM_FILE} ${TMP_LOC}/${LOG_FILE}
	  if test $? -ne 0
	  then
		echo "-*> The zip process failed. Running cleanup and exiting."
		echo "-*> Check reason for failure."
		clean_up
		exit 2
	  fi
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
	if test -s ${INV_LOC}/${INV_FILE}
	then
	  cp ${INV_LOC}/${INV_FILE} ${TMP_LOC}/${NEW_INV_FILE}
	  ${ZIP_PROG} -jm ${TMP_LOC}/${ZIP_FILE} ${TMP_LOC}/${NEW_INV_FILE}
	else
	  echo "-*> Invoice files does not exist..."
	  exit 1
	fi
}


#
# Transfer file
transfer_file()
{
	if test -a ${TMP_LOC}/${ZIP_FILE}
	then
          ${TR_PROG} ${TR_ID} ${TMP_LOC}/${ZIP_FILE}
          if test $? -ne 0
            then
                echo "*-> Transfer of file failed"
                clean_up
                exit 1
            fi
	else
	   echo "--*> File not copied..."
	fi
}


#
# Cleanup
clean_up()
{
	rm -f ${TMP_LOC}/${ZIP_FILE}
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
echo "--> Transferring file..."
echo

transfer_file

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
