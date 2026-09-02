#!/bin/ksh
#
# Program Name	: card81_extract.sh
# Description	: Runs procedure to do an extract on the CARDH81MAS file
#		  NOTE: date inputs on rsh of claims_load.sh need changed at beginning of the year.
# Author	: Linda S. Jefferis
# Date		: 03/12/2001
# Modifications : 05/16/2002 - Removed Redbrick/Bigred logic  (LSJ)
#		: 10/19/2009 - Added copy to COLO site system  (LSJ)
#		: 02/08/2010 - Fixed FILE_PATH variable  (LSJ)
#		: 07/02/2010 - Additions for creating dated file in clientfiles area  (LSJ)
#		: 10/26/2012 - Changed FILE_DATE to "weekly" date
#		: 03/10/2016 - TT13309-6
#               : 04/22/2026 - added AWS location copy 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/sqlimports/misc"
FLEX="/usr/lnk/flexgen"
EXTRACT_FILE="CARD81"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
ZIP_PROG="/bin/gzip"
AWS_DIR="s3://ga-internal-transfers/PDMI/Extracts/"
AWS_CP="/usr/local/bin/aws s3 cp"
AWS_CP_OPTS="--only-show-errors"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: card81_extract.sh 

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
        ${AWS_CP} ${FNAME}.gz ${AWS_DIR} ${AWS_CP_OPTS}
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

cd ${FLEX}

echo "--> Extracting ${EXTRACT_FILE} - car81pc3.cs"
date
${FLEX}/car81pc3.cs
date

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
