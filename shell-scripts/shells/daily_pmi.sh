#!/bin/ksh
#
# Program Name	: daily_pmi.sh
# Description	: Daily claims extract for PMI
# Author	: Linda S. Jefferis
# Date		: 07/19/2001
# Modifications : 07/30/2001 - Fixed filename from ???CL119DAYPMI to ???CL119DAY  (LSJ)
#		: 08/14/2001 - Removed SUFFIX(.csv) off of filename  (LSJ)
#		: 02/01/2005 - Fixed output tape name  (LSJ)
#		: 10/17/2005 - Changes for linux commands  (LSJ)
#		: 12/19/2005 - Changed OUTPUT_DIR and moved run from Rook to Husk  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL="/usr/lnk/shell"
RPT="/usr/lnk/rpt"
TAPE_DIR="/usr/lnk/tapes"
OUTPUT_DIR="/usr/lnk/shares/ftp-tmp"
FILE="pmi"
DATE=`/usr/local/bin/yesterday`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_pmi.sh 

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
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

umask 000

date
echo 
echo "--> Running claim119...."
${SHELL}/claim119.sh -c day > ${RPT}/claim119 2>&1
date

echo
echo "CLAIM119 COUNTS:"
echo "`grep "WRITTEN" ${RPT}/claim119`"

echo 
echo "--> Moving claim119 claims file..."
mv ${TAPE_DIR}/???CL119DAY-? ${OUTPUT_DIR}/${FILE}${DATE}
STATUS=$?
if [ ${STATUS} -ne 0 ]
then
    echo
    echo "-*> Error moving the file"
    echo "-*> Move command = mv ${TAPE_DIR}/???CL119DAY ${OUTPUT_DIR}/${FILE}${DATE}"
else
    date
    echo
    echo "-=> Procedure is completed."
fi

exit 0
