#!/bin/sh
#
# Program Name	: claim137-whclaims.sh
# Description	: Process to create claim72pdm file from Claim137 CLAIM72KEY file for Warehouse to update.
#		  Command Line:
#		  -f <clwrk>
# Author	: Linda Jefferis
# Date		: 11/02/2020
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/tmp"
CL72_FILE="???CL72-U-PDM"
INSRTFILE=/usr/lnk/keys/CLAIM72KEY-CLAIM137
OUTSRTFILE=/usr/lnk/keys/CLAIM72KEY-U
RUNTYPE="cl137"
OUT_DIR="claims/Claims137"
SQL_DIR="/usr/lnk/wt/sqlimports"
MAIL_PROG="/usr/bin/mutt"
MAIL_OPER="operations@pdmi.com"
ZIP_PROG="/bin/gzip"
SQL_FNAME="Claims137"
TR_ERR=0
DATE=`date +%Y%m%d%H%M%S`
AWS_DIR=/usr/lnk/wt/oper-wt/CLAIM72PDM
CLWRK_FLG=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim137-whclaims.sh 

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
        ${ZIP_PROG} ${FNAME}
	cp ${FNAME}.gz ${AWS_DIR}
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "${FNAME} not copied"
                TR_ERR=1
        fi
else
        echo "${FNAME} does not exist"
fi
}

# Error process
error_proc()
{
	echo "-*> Error with ${procname}. Aborting."
	exit 99
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	BATCHRNGE=$1
	;;
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	CLWRK_FLG=1
	CLWRK=$1
	FNAME=`basename ${CLWRK}`
	;;
  esac
  shift
done


# Parse environment variables
#parse_env

${SHELL_DIR}/claim72srt.sh -i ${INSRTFILE} -o ${OUTSRTFILE} > /usr/lnk/rpt/cl137-claim72srt 2>&1
if test $? -ne 0
then
	procname="claim72srt.sh"
	error_proc
fi

if [ ${CLWRK_FLG} = 1 ]
then
	${SHELL_DIR}/claim72pdm.sh -c ${RUNTYPE} -f ${CLWRK} > ${RPT_DIR}/${RUNTYPE}-${FNAME}-claim72pdm 2>&1
else
	${SHELL_DIR}/claim72pdm.sh -c ${RUNTYPE} > ${RPT_DIR}/${RUNTYPE}-claim72pdm 2>&1
fi
if test $? -ne 0
then
        procname="claim72pdm.sh"
        error_proc
fi
REC_CNT=`wc -l ${FILE_PATH}/${CL72_FILE} | awk '{ print $1 }'`
if test $? -ne 0
then
        procname="Getting Record Count"
        error_proc
fi
mv ${FILE_PATH}/${CL72_FILE} ${FILE_PATH}/${SQL_FNAME}-${DATE}
if test $? -ne 0
then
        procname="Moving File"
        error_proc
fi
FNAME=${FILE_PATH}/${SQL_FNAME}-${DATE}
file_transfer

if [ $TR_ERR != 0 ]
then
        echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "Claim137 - Claims Corrections" ${MAIL_OPER}
fi

date

exit ${RETVAL}
