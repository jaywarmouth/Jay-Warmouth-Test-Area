#!/bin/sh
#
# Program Name	: clms_quantum_wchp.sh
# Description	: Procedure to setup claims file for Wooster (sys0116) and send to Quantum.
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 03/06/2009
# Modifications : 05/07/2009 - Added logic for sending TOT_FILE  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL109QTM-T-QTM"
TEXT_FILE="???QTMTEXT"
TRANSFER_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="QUAN"
DATE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_quantum_wchp.sh -p <p/e date>
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
	CLM_FILE="wchp-${DATE}.txt"
	TOT_FILE="totals-wchp-${DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  cp ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  cp ${FILE_LOC}/${TEXT_FILE} ${TMP_LOC}/${TOT_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}


# Cleanup
clean_up()
{
	rm ${TMP_LOC}/${CLM_FILE}
	rm ${TMP_LOC}/${TOT_FILE}
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
${TRANSFER_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE} ${TMP_LOC}/${TOT_FILE}

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
