#!/bin/ksh
#
# Program Name	: clms_ingenix_schnucks.sh
# Description	: Procedure to setup claims file for sys121 to send to Ingenix
#		  Command Line Arguments:
#		  -p <mmccyy>  M/E date
# Author	: Linda S. Jefferis
# Date		: 11/12/2010
# Modifications : 12/23/2011 - Changed TR_ID from INGX to UHC and changed to D0 format
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="???CL109D0-M-SMK"
LOG_FILE="???CL109D0-M-SMKTEXT"
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="300"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="UHC"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_ingenix_schnucks.sh -p <m/e date>
	<m/e date> is month ending date in mmccyy format  (required)

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	set $VAR
	NVAR=$1
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Split out m/e date
conv_date()
{
        MON=`echo ${PE_DATE} | cut -c1-2`
        YEAR=`echo ${PE_DATE} | cut -c3-6`
}



#
# Set Filenames
set_filenames()
{
	CLM_FILE="schnucks${PE_DATE}.txt"
	ZIP_FILE="schnucks${PE_DATE}.zip"
	NEW_LOG="totals.txt"
}


#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  cp ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  cp ${FILE_LOC}/${LOG_FILE} ${TMP_LOC}/${NEW_LOG}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# Zip files
zip_files()
{
	${ZIP_PROG} -mj ${TMP_LOC}/${ZIP_FILE} ${TMP_LOC}/${CLM_FILE} ${TMP_LOC}/${NEW_LOG}
}

#
# Copy files
copy_files()
{
	if test -f ${TMP_LOC}/${ZIP_FILE}
	then
	   ${TR_PROG} ${TR_ID} ${TMP_LOC}/${ZIP_FILE}
	   if test $? -ne 0
           then
                echo "*-> Transfer of file failed"
           fi
	else
	   echo "--*> File not copied..."
	fi
}

#
# Cleanup
clean_up()
{
	rm ${TMP_LOC}/${ZIP_FILE}
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

# Parse environment variables
#parse_env

set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo
echo "--> Zipping current files..."
echo

zip_files

echo 
echo "--> Transferring file to ${TR_ID}..."
echo

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
