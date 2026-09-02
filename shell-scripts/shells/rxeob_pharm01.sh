#!/bin/sh
#
# Program Name	: rxeob_pharm01.sh
# Description	: Extract of Network #999 Pharm data for RXEOB
# Author	: Linda S. Jefferis
# Date		: 07/13/2005
# Modifications : 10/28/2005 - Changes for Linux  (LSJ) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/tapes"
EXTRACT_FILE="PHARM01-999"
NET=000999
NETWRK_DIR="/usr/lnk/wt/oper-wt/RxEOB"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_pharm01.sh 

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

date
echo "      --> Starting pharm01.sh"
${SHELL_DIR}/pharm01.sh -o ${NET} > ${RPT_DIR}/pharm01.rxeob 2>&1
date
echo "      --> pharm01.sh has completed"

echo "      --> Zipping ${EXTRACT_FILE} to Network Directory"
mv ${FILE_PATH}/???${EXTRACT_FILE} ${FILE_PATH}/PHARM_${DATE}.txt
${ZIP_PROG} -jm ${NETWRK_DIR}/${DATE}.zip ${FILE_PATH}/PHARM_${DATE}.txt
if test $? -ne 0
then
   echo "-*> zip of ${EXTRACT_FILE} failed"
   exit 1
fi
date


exit 0
