#!/bin/sh
#
# Program Name	: wh_clmss.sh
# Description	: Runs clmssrb01.sh, efssrb001.sh, and gets files to sqlimports/claims area,
# Author	: Linda S. Jefferis
# Date		: 12/16/2014
# Modifications : 02/09/2015 - TT #11675-22
#		: 02/23/2015 - Added "PATH=/usr/rmcobol:$PATH" due to 3402 error received when runs in crontab.
#		: TT #13309-2
#		: TT #12829-45 - DATECARD logic
#		: TT16089-7 - addition of efssrb001.sh processing.
#		: TT15263-22 - eftrafrb001.sh logic
#		: TT18207-22 - scss01.sh logic
#		: FVF Phase I - add fvss01 logic.
#		: 3/8/2022 - changed logic for scss01.sh
#		: 07/27/2022 - added "tittracrb01" logic
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
PATH=/usr/rmcobol:/usr/local/bin:$PATH
ZIP_PROG="/bin/gzip"
DATE=`date -d "yesterday 0800" +%Y%m%d`
DAY=`date +%w`
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="claims"
AWS_DIR="s3://ga-internal-transfers/PDMI/Extracts/"
AWS_CP="/usr/local/bin/aws s3 cp"
AWS_CP_OPTS="--only-show-errors"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_clmss.sh 

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
                echo "Error with transfer of ${FNAME}"
        fi
        mv ${CNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${CNAME}"
        fi
else
        echo "${FNAME} does not exist"
fi
date
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# CLMSS00MAS extract
if [ $DAY = 0 ]
then
	${SHELL_DIR}/clmssrb01.sh -b last7days 2>&1
else
	${SHELL_DIR}/clmssrb01.sh -b yesterday 2>&1
fi
FNAME=${CLMSSRB001}
file_transfer

# TITTRACMAS extract
if [ $DAY = 0 ]
then
	${SHELL_DIR}/tittracrb01.sh -b last7days 2>&1
else
	${SHELL_DIR}/tittracrb01.sh -b yesterday 2>&1
fi
FNAME=${TITTRACRB01}
file_transfer

# EFSS000MAS extract
if [ $DAY = 0 ]
then
	${SHELL_DIR}/efssrb001.sh -b last7days 2>&1
else
	${SHELL_DIR}/efssrb001.sh -b yesterday 2>&1
fi
FNAME=${EFSSRB001}
file_transfer

# ETRAF00MAS extract
${SHELL_DIR}/etrafrb001.sh -b yesterday 2>&1
FNAME=${ETRAFRB001}
# Reassign OUT_DIR for this specific file extract
ORIG_OUT_DIR=$OUT_DIR
OUT_DIR=misc
file_transfer
# Reset OUT_DIR back to original setting
OUT_DIR=$ORIG_OUT_DIR

# SCSS000MAS extract
if [ $DAY = 0 ]
then
        ${SHELL_DIR}/scss01.sh -b last7days 2>&1
else
        ${SHELL_DIR}/scss01.sh -b yesterday 2>&1
fi
FNAME=${SCSSRB0001}
file_transfer

# FVSS000MAS extract
${SHELL_DIR}/fvss01.sh 2>&1
FNAME=${FVSSRB0001}
file_transfer

exit 0
