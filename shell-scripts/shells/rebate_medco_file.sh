#!/bin/ksh
#
# Program Name	: rebate_medco_file.sh
# Description	: Procedure to prepare file and email notification
#		  Command Line Arguments:
#		  -p <ccyymm>  File date
# Author	: Linda S. Jefferis
# Date		: 05/04/2011
# Modifications : 06/22/2011 - Added logic for getting file to PGP10 before enctypting and file_transfer logic for providing file to Warehouse.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_DIR="/usr/lnk/shares/ftp-tmp"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
ZIP_PROG="/usr/bin/zip"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebate_medco_file.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	REB_FILE="RB-MEDCO-${PE_DATE}"
}

#
record_count()
{
	if test -s ${FILE_LOC}/${REB_FILE}
	then
	  REC_CNT=`wc -l ${FILE_LOC}/${REB_FILE} | awk '{print $1}'`
	else
	  echo "-*> Rebate file, ${FILE_LOC}/${REB_FILE}, does not exist..."
	  exit 1
	fi
}

#
# Copy files
copy_files()
{
	cp ${FILE_LOC}/${REB_FILE} ${TMP_DIR}
	${ZIP_PROG} -j ${TMP_DIR}/${REB_FILE}.zip ${FILE_LOC}/${REB_FILE}
	FNAME=${TMP_DIR}/${REB_FILE}
	file_transfer	
 	echo "The rebate file, ${REB_FILE}, has been uploaded. \rThe Record Count (including header and trailer records) = ${REC_CNT}." | ${MAIL_PROG} -s "PDMI-Medco Rebate File Notification" ${MAIL_TO}
}

#
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        gzip ${FNAME}
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${FNAME}"
        fi
else
        echo "${FNAME} does not exist"
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
echo "--> Determine record count..."
echo

record_count

echo 
echo "--> Copying file to ${TMP_DIR}..."
echo

copy_files

echo "-> Encrypt and transfer the file using PGP10 server."
echo "-> Once file is uploaded, forward email to:"
echo "   Lee Godin (Lee_Godin@express-scripts.com) and Warehouse@pdmi.com."

echo "-=> Finished."

exit 0
