#!/bin/ksh
#
# Program Name	: rv601_process.sh
# Description	: Concatenates previous day's RV601-???-ccyymmdd files to one file and uploads to sqlimports/audit as RV601-ccyymmdd for Warehouse updating.
#		Command line Arguments:
#			-d <ccyymmdd> - alternate date
# Author	: Linda Jefferis
# Date		: 06/13/2012
# Modifications : 04/07/2014 - changed logic for files from prod11/prod20 based on other changes made to cp_audit.sh and cp_audit_prod20.sh scripts (TT #10512-1)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date -d "yesterday 0800" +%Y%m%d`
AUD_DIR="/usr/lnk/audit"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="audit"
WH_DIR=/usr/lnk/sqlimports/${OUT_DIR}
RV601="RV601-???-"
AWS_DIR="s3://ga-internal-transfers-dev/PDMI/AuditExtracts/"
AWS_CP="/usr/local/bin/aws s3 cp"
AWS_CP_OPTS="--only-show-errors"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rv601_process.sh <-d ccyymmdd>
	if "-d" not used, date is yesterday

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
	REC_CNT=`wc -l ${FNAME} | awk '{ print $1 }'`
        CNAME=${FNAME}-counts-${DATE}
        echo ${REC_CNT}","${DATE} > ${CNAME}
	mv ${FNAME} ${FNAME}-${DATE}
        gzip ${FNAME}-${DATE}
	gzip ${CNAME}
	${AWS_CP} ${FNAME}-${DATE}.gz ${AWS_DIR} ${AWS_CP_OPTS}
        ${AWS_CP} ${CNAME}.gz ${AWS_DIR} ${AWS_CP_OPTS}
        mv ${FNAME}-${DATE}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${FNAME}-${DATE}"
        fi
	mv ${CNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${CNAME}"
        fi
else
        echo "${FNAME} does not exist"
fi
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	;;
esac
  shift
done

echo "FILE_DATE=$DATE"
#cat ${AUD_DIR}/${RV601}${DATE}.prod?? >> ${WH_DIR}/RV601
cat ${AUD_DIR}/${RV601}${DATE} >> ${WH_DIR}/RV601
FNAME=${WH_DIR}/RV601
file_transfer

echo "Record Count for RV601-${DATE} is:  ${REC_CNT}"

exit 0
