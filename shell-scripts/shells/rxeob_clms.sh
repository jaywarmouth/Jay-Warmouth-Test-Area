#!/bin/ksh
#
# Program Name	: rxeob_clms.sh
# Description	: Extract of SummaCare Claims data for RXEOB
# Author	: Linda S. Jefferis
# Date		: 11/23/2001
# Modifications : 07/13/2005 - Removed the claim111 procedure. It was moved to daily_proc.sh 
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 05/30/2006 - Added rm -f ???-P-HRMBTEXT command  (LSJ)
#		: 12/28/2007 - Changed name of EXTRACT_FILE due to new claim111rx procedure  (LSJ)
#		: 09/06/2013 - change zip file name to rxeobclms_ccyymmdd.zip (DME)
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR=""
EQUAL="="
DATE=`date +%m%d%Y`
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/tapes"
EXTRACT_FILE="CL111RXDAY-?-RXEOB"
NETWRK_DIR="/usr/lnk/rxeob"
ZIP_PROG="/usr/bin/zip"
FILE_DATE=`date +%Y%m%d`
CLM_FILE="rxeobclms_${FILE_DATE}.zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_clms.sh 

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


if test -s ${FILE_PATH}/???${EXTRACT_FILE}
then
   echo "      --> Zipping ${EXTRACT_FILE} to Network Directory"
   rm -f ${FILE_PATH}/???-P-HRMBTEXT
   mv ${FILE_PATH}/???${EXTRACT_FILE} ${FILE_PATH}/CLMS_${DATE}.txt
   ${ZIP_PROG} -jm ${NETWRK_DIR}/${CLM_FILE} ${FILE_PATH}/CLMS_${DATE}.txt
   if test $? -ne 0
   then
      echo "-*> zip of ${EXTRACT_FILE} failed"
      exit 1
   fi
   date
else
   echo "-*> NO RXEOB CLAIMS FILE"
fi

exit 0
