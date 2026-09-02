#!/bin/ksh
#
# Program Name	: rxeob_limit.sh
# Description	: Extract of LIMIT data for RXEOB
# Author	: Linda S. Jefferis
# Date		: 01/25/2005
# Modifications : 10/28/2005 - Changes for Linux  (LSJ) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/rxeob"
FLEX="/usr/lnk/flexgen"
EXTRACT_FILE="LIMIT"
NETWRK_DIR="/usr/lnk/shares/rxeob"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_limit.sh 

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

umask 002

cd ${FLEX}

date
echo "      --> Extracting ${EXTRACT_FILE} - ohlimpc001.cs"
${FLEX}/ohlimpc001.cs
date

echo "      --> Zipping ${EXTRACT_FILE} to Network Directory"
mv ${FILE_PATH}/${EXTRACT_FILE} ${FILE_PATH}/${EXTRACT_FILE}_${DATE}.txt
${ZIP_PROG} -jm ${NETWRK_DIR}/${DATE}.zip ${FILE_PATH}/${EXTRACT_FILE}_${DATE}.txt
if test $? -ne 0
then
   echo "-*> zip of ${EXTRACT_FILE} failed"
   exit 1
fi
date


exit 0
