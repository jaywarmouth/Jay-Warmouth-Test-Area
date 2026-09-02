#!/bin/sh
#
# Program Name	: qrtly_ennis_ingx.sh
# Description	: Procedure to setup claims file for Ennis/Ingenix (sys0076)
#		  Command Line Arguments:
#		  -p <ccyymmdd_ccyymmdd>  Quarter begin and end dates
# Author	: Linda S. Jefferis
# Date		: 03/15/2007
# Modifications : 09/11/2007 - Changed LOG_FILE name  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL109EN-Q-ENNI"
LOG_FILE="???ENNI-Q-TEXT"
TRANSFER_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="INGX"
DATE="null"
GZIP_PROG="/bin/gzip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: qrtly_ennis_ingx.sh -p <date>
	<date> is quarter begin and end dates in ccyymmdd_ccyymmdd format  (required)

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
	CLM_FILE="ennis_clmdata_${DATE}.txt"
	NEW_LOG="ennis_cntlrpt_${DATE}.txt"
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
# gzip files
gzip_files()
{
	${GZIP_PROG} ${TMP_LOC}/${CLM_FILE}
	${GZIP_PROG} ${TMP_LOC}/${NEW_LOG}
}


# Cleanup
clean_up()
{
	rm ${TMP_LOC}/${CLM_FILE}.gz
	rm ${TMP_LOC}/${NEW_LOG}.gz
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

gzip_files

echo 
echo "--> Transferring file to ${TR_ID}..."
echo
${TRANSFER_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE}.gz ${TMP_LOC}/${NEW_LOG}.gz

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
