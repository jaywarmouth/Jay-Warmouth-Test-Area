#!/bin/sh
#
# Program Name	: clms_tsc_umr.sh
# Description	: Procedure to setup claims file for TSC-UMR sponsors and send to UMR
#		  Command Line Arguments:
#		  -p <mmddccyy>  
# Author	: Linda S. Jefferis
# Date		: 09/25/2014
# Modifications : 07/29/2016 - add "MDSD53_P_" prefix (TT:15562-3; DME)
#		: 06/16/2022 - Change of secure_transfer logic to direct copy of file(s) to run on Prod10
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC=/usr/lnk/wt/oper-wt/sftpexport/UMR
TAPE_FILE="???CL109GRAN-W-TSC"
TEXT_FILE="???TSCTEXT"
PE_DATE="null"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="CustomerReportingRX@umr.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_tsc_umr.sh -p <p/e date>
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
	CLM_FILE="MDSD53_P_Weeklyclms-EMS-${PE_DATE}.txt"
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

if test -s ${FILE_LOC}/${TAPE_FILE}
then
	echo 
	echo "--> Transferring file to ${DEST_LOC} for distribution"
	echo
	cp ${FILE_LOC}/${TAPE_FILE} ${DEST_LOC}/${CLM_FILE}
	if test $? -eq 0
	then
		cat ${FILE_LOC}/${TEXT_FILE} | ${MAIL_PROG} -s "TrueScripts-UMR Rx Claims File Notification" -c ${MAIL_CC} ${MAIL_TO}
	else
		echo "-*> File Transfer failed..."
	fi
else
	echo "-*> Claims file does not exist..."
	exit 1
fi

echo "-=> Finished."

exit 0
