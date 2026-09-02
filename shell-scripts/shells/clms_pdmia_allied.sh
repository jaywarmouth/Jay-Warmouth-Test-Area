#!/bin/sh
#
# Program Name	: clms_pdmia_allied.sh
# Description	: Procedure to setup claims file for PDMIA-Casino Queen (168-1426)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 12/17/2014
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL109D0-P-ALLI"
TRANSFER_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="ALLI"
DATE="null"
MAIL_PROG="/bin/mail"
MAIL_TO="dmnotification@alliedbenefit.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_pdmia_allied.sh -p <p/e date>
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

#
# Set filenames
set_filenames()
{
	CLM_FILE="casino_queen_claims_${DATE}.txt"
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
	DATE=$1
	set_filenames
	;;
  esac
  shift
done

# Parse environment variables
#parse_env

if [ $DATE = "null" ]
then
	usage
	exit 1
fi

echo
echo "--> Converting file..."
echo

rename_files


echo 
echo "--> Transferring file to ${TR_ID}..."
echo
${TRANSFER_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE}
echo "The file, ${CLM_FILE}, is now available to download." | ${MAIL_PROG} -s "Casino Queen Claims File Notification" -c ${MAIL_CC} ${MAIL_TO}

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
