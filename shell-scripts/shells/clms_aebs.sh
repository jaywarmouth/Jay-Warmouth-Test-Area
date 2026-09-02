#!/bin/ksh
#
# Program Name	: clms_aebs.sh
# Description	: Procedure to setup claims file for AEBS (sys102)
#		  This is run on Rook
#		  Command Line Arguments:
#		  -p <ccyymmdd>  current date
# Author	: Linda S. Jefferis
# Date		: 03/08/2006
# Modifications : 04/02/2008 - Changed email procedure  (LSJ)
#		: 04/24/2008 - Fixed email address fro bbrinkman  (LSJ)
#		: 04/08/2014 - Added sgriggs@my-benovation.com to MAIL_TO
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/wt/aebs-wt"
TMP_LOC="/tmp"
TAPE_FILE="???CL109-T-AEBS"
LOG_FILE="???AEBSTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="300"
MAIL_PROG="/bin/mail"
MAIL_TO="bbrinkman@aebsbenefits.com sgriggs@my-benovation.com"
MAIL_CC="operations@pdmi.com"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_aebs.sh -p <current date - mmddccyy>

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
# Set Filenames
set_filenames()
{
	ZIP_FILE="clms_pdmi${DATE}.zip"
	CLM_FILE="clms_pdmi${DATE}.txt"
	NEW_LOG="totals${DATE}.txt"
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
	   mv ${TMP_LOC}/${ZIP_FILE} ${DEST_LOC}
	   echo "The file, ${ZIP_FILE}, is now available to download." | ${MAIL_PROG} -s "AEBS WEEK CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
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
	DATE=$1
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

zip_files

echo 
echo "--> Copying file to ${DEST_LOC}..."
echo

copy_files

echo "-=> Finished."

exit 0
