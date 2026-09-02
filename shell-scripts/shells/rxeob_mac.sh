#!/bin/sh
#
# Program Name	: rxeob_mac.sh
# Description	: Extract of MAC Table data for RXEOB
# Author	: Linda S. Jefferis
# Date		: 03/22/2004
# Modifications : 10/28/2005 - Changes for Linux  (LSJ) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
SHELL="/usr/lnk/shell"
RPT="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/rxeob"
EXTRACT_FILE="MAC"
NETWRK_DIR="/usr/lnk/wt/oper-wt/RxEOB"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_mac.sh 

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
# Process MAC
process_mac()
{
	echo "      --> Extracting ${EXTRACT_FILE} - mac003.sh"
	${SHELL}/mac003.sh > ${RPT}/mac003 2>&1
	date

	echo "      --> Zipping ${EXTRACT_FILE} to Network Directory"
	mv ${FILE_PATH}/${EXTRACT_FILE} ${FILE_PATH}/${EXTRACT_FILE}_${DATE}.txt
	${ZIP_PROG} -jm ${NETWRK_DIR}/${DATE}.zip ${FILE_PATH}/${EXTRACT_FILE}_${DATE}.txt
	if test $? -ne 0
	then
   	   echo "-*> zip of ${EXTRACT_FILE} failed"
           exit 1
	fi
}


#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

umask 002

date

process_mac

date

exit 0
