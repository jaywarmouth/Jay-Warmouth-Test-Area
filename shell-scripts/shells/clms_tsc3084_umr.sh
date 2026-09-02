#!/bin/sh
#
# Program Name	: clms_tsc.sh
# Description	: Procedure to setup claims file for TSC/EXMS and send to UMR
#		  Command Line Arguments:
#		  -p <mmddccyy>  
# Author	: Linda S. Jefferis
# Date		: 04/28/2014
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL109GRAN-W-TEMS"
TEXT_FILE="???TEMSTEXT"
TRANSFER_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="UMR"
PE_DATE="null"
MAIL_PROG="/bin/mail"
MAIL_TO="CustomerReportingRX@umr.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_tsc3084_umr.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

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

# Convert input date
conv_date()
{
        MO=`echo ${IN_DATE} | cut -c1-2`
        DAY=`echo ${IN_DATE} | cut -c3-4`
        YR=`echo ${IN_DATE} | cut -c5-8`
        PE_DATE=${YR}${MO}${DAY}
}

#
# Set filenames
set_filenames()
{
	CLM_FILE="Weeklyclms-EMS-${PE_DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  cp ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}


# Cleanup
clean_up()
{
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
	IN_DATE=$1
	conv_date
	;;
  esac
  shift
done

# Parse environment variables
#parse_env

if [ $IN_DATE = "null" ]
then
	usage
	exit 1
fi

set_filenames

echo
echo "--> Rename files..."
echo

rename_files

echo 
echo "--> Transferring file to ${TR_ID}..."
echo
${TRANSFER_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE} 
if test $? -eq 0
then
	cat ${FILE_LOC}/${TEXT_FILE} | ${MAIL_PROG} -s "TrueScripts-EMS Rx Claims File Notification" -c ${MAIL_CC} ${MAIL_TO}
else
	echo "-*> File Transfer failed..."
fi

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
