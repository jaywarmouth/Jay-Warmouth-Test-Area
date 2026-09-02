#!/bin/sh
#
# Program Name	: wh_medsub_claims.sh
# Description	: Procedure to create claims extract file for Warehouses
#		  Command Line Arguments:
#			yyyymmdd - Claim process date
# Author	: Linda S. Jefferis
# Date		: 04/13/2018
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
#PATH=/usr/rmcobol:$PATH
RPT_DIR="/usr/lnk/rpt"
ZIP_PROG="/bin/gzip"
FILE1=WHCL
FILE2=MedSubClaims
DIR_1=/usr/lnk/opswt/MEDSUB/HMS
WH_DIR=/usr/lnk/sqlimports/claims
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="claims"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
MAIL_PROG=/bin/mail
MAIL_TO="ljefferis@pdmi.com"
RETVAL=0
FILEDATE=`date -d "yesterday 0800" +%Y%m%d`
AWS_DIR="/usr/lnk/wt/oper-wt/CLAIM72PDM"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_medsub_claims.sh yyyymmdd
	where yyyymmdd is claim process date
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



# Claims Extract
claim_extract()
{
	echo
	echo "--> Starting claims extract - claim72pdm"
	${SHELL_DIR}/claim72pdm.sh -c medsub -r "${BATCHRNGE}${DIR_1}/${FILE1}" > ${RPT_DIR}/claim72pdm-medsub 2>&1
	RETVAL="$?"
	mv ${DIR_1}/${FILE1} ${WH_DIR}/${FILE2}-${FILEDATE}

	if test -s ${WH_DIR}/CL72-COUNTS-M
	then
		mv ${WH_DIR}/CL72-COUNTS-M ${WH_DIR}/MedSubClaims-counts-${FILEDATE}
		FNAME=${WH_DIR}/MedSubClaims-counts-${FILEDATE}
		file_transfer
	else
		echo ""
		echo "-*> The file, ${WH_DIR}/CL72-COUNTS-M is not available"
	fi

	FNAME=${WH_DIR}/${FILE2}-${FILEDATE}
	file_transfer
	mail_process
}


# Email to Operations
mail_process()
{
cat ${RPT_DIR}/claim72pdm-medsub | ${MAIL_PROG} -s "claim72pdm-medsub output" ${MAIL_TO}
}


#
# Main routine
#

if [ $# -le 0 ]
then
	usage
fi
PROCDATE=$1
BATCH=`/usr/lnk/shell/convert_to_batch.sh $PROCDATE`
BATCHRNGE=${BATCH}M000${BATCH}M999

umask 111


# Parse environment variables
parse_env

claim_extract

exit $RETVAL
