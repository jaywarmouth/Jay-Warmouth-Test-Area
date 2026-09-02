#!/bin/ksh
#
# Program Name	: card80_rbextract.sh
# Description	: Runs procedure to do an extract on the CARDH80MAS file
#		  NOTE: date inputs on rsh of claims_load.sh need changed at beginning of the year.
# Author	: Linda S. Jefferis
# Date		: 05/18/2000
# Modifications : 06/05/2000 - Added submit(rsh) of CARD80 update on Bigred  (LSJ) 
#		: 07/24/2000 - Added STATUS_FILE logic  (LSJ)
#		: 04/11/2001 - Changed some displays and the rsh procedure  (LSJ)
#		: 05/16/2002 - Removed Redbrick/Bigred logic  (LSJ)
#		: 10/19/2009 - Added copy to COLO site system  (LSJ)
#		: 11/01/2009 - Fixed copy to COLO  (LSJ)
#		: 01/15/2010 - Changed for copy to Site 2  (LSJ)
#		: 05/20/2010 - Added logic for dual copy of file to FILE10/FILE20
#		: 06/25/2010 - Fixed dual copy dates to assign Friday's date to file.
#		: 01/13/2011 - Removed logic for prod21 copy
#		: 01/09/2015 - replaced car80rb2 process with cobol cardh80rb1 process (TT #12334-12).
#		: 03/10/2016 - TT13309-6
#		: 05/26/2020 - adding AWS_DIR and copy of extract to the direcotry for (CC: 10196; DME)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/sqlimports/misc"
EXTRACT_FILE="CARD80RB"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
AWS_DIR="/usr/lnk/wt/oper-wt/CARD80RB"
ZIP_PROG="/bin/gzip"
SHELL_DIR=/usr/lnk/shell
RPT_DIR=/usr/lnk/rpt

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: card80_rbextract.sh 

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
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        gzip ${FNAME}
	cp ${FNAME}.gz ${AWS_DIR}
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${FNAME}"
        fi
else
        echo "${FNAME} does not exist"
fi
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

${SHELL_DIR}/cardh80rb1.sh > ${RPT_DIR}/card80rb1 2>&1

DAY=`date +%w`
if [ $DAY = 6 ]
then
	FILE_DATE=`date -d "yesterday 0800" +%Y%m%d`
fi
if [ $DAY = 0 ]
then
	FILE_DATE=`date -d "-2 days 0800" +%Y%m%d`
fi
mv ${FILE_PATH}/${EXTRACT_FILE} ${FILE_PATH}/${EXTRACT_FILE}-${FILE_DATE}
FNAME=${FILE_PATH}/${EXTRACT_FILE}-${FILE_DATE}
file_transfer

exit 0
