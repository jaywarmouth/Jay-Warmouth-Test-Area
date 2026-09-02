#!/bin/ksh
#
# Program Name	: dbp_daily_claims.sh
# Description	: Procedure to create test claims extract file for DBPronto
#		  Command Line Arguments:
# Author	: Linda S. Jefferis
# Date		: 09/15/2010
# Modifications : 03/10/2016 - TT13309-6
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
FILE1=CL72-D-PDM
FILE2=DBPCL72
DIR_1=/usr/lnk/tmp
WH_DIR=/usr/lnk/sqlimports/test
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="test"
DATE=`date -d "yesterday 0800" +%Y%m%d`
PROCESS_DATE=`date -d "yesterday 0800" +%Y%m%d`
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
MAIL_PROG=/bin/mail
MAIL_TO="mpaulus@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dbp_daily_claims.sh

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
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
          echo "^G-*> Parse Error on Line: "${VAR}
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
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${FNAME}"
        fi
else
        echo "${FNAME} does not exist"
fi
}


# Claims Extract
claim_extract()
{
	echo
	echo "--> Starting claims extract - claim72pdm_dbp"
	${SHELL_DIR}/claim72pdm_dbp.sh -c day > ${RPT_DIR}/claim72pdmd_dbp 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/claim72pdmd_dbp`"
	mv ${DIR_1}/???${FILE1} ${WH_DIR}/${FILE2}-${DATE}
	REC_CNT=`wc -l ${WH_DIR}/${FILE2}-${DATE} | awk '{ print $1 }'`
	echo ${REC_CNT}","${PROCESS_DATE} > ${WH_DIR}/wh_daily_claims_count-${DATE}
        FNAME=${WH_DIR}/wh_daily_claims_count-${DATE}
        file_transfer
        FNAME=${WH_DIR}/${FILE2}-${DATE}
        file_transfer
	mail_process
}

# Email to Mike Paulus
mail_process()
{
cat ${RPT_DIR}/claim72pdmd_dbp | ${MAIL_PROG} -s "DBP claim72pdmd output for ${PROCESS_DATE}" ${MAIL_TO}
}


#
# Main routine
#


# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

claim_extract

exit 0
