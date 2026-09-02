#!/bin/sh
#
# Program Name	: clms_trx_medb_claim109d0.sh
# Description	: Procedure to setup and transfer claims file for sponsor trx_medb and upload to MedBen
#		  Command Line Arguments:
#		  -p <mmdd>  P/E date
# Author	: Linda S. Jefferis
# Date		: 01/10/2012
# Modifications : 
#		: 05/15/2014 - Replacement of the cbrooks@medben.com email address with wmillard@medben.com TT:10917-1 (DME)
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL109D0-W-RTC"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="MEDBEN"
DATE="null"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="300"
MAIL_PROG="/bin/mail"
MAIL_TO="jharris@medben.com wmillard@medben.com edanner@medben.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_trx_medb_claim109d0.sh -p <p/e date>
	<p/e date> is period ending date in mmdd format  (required)

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
	CLM_FILE="TRX_claim109d0${DATE}"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_LEN} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
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
${TR_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE}
if test $? -ne 0
then
	echo "*-> Transfer of file failed"
	clean_up
	exit 1
fi
echo "-=> file copied..."
echo "The weekly claim109d0 TRX claims file for p/e ${DATE} is now available." | ${MAIL_PROG} -s "WEEKLY FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
