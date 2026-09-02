#!/bin/sh
#
# Program Name	: chk-whclaims.sh
# Description	: Process to create claim72pdm file from Check Run CLWRK file for Warehouse to update to Financial Database.
#		  Command Line:
#		  -b <chkrun batch range>
#		  -f <clwrk>
# Author	: Linda Jefferis
# Date		: 8/23/2013
# Modifications :  03/10/2016 - TT13309-6
#		: 07/06/2016 - TT15910-1
#		: 10/20/2021 - Cherwell #32867 - File to AWS
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
CYCLE="chk"
OUT_DIR="claims"
SQL_DIR="/usr/lnk/wt/sqlimports"
MAIL_PROG="/usr/bin/mutt"
MAIL_OPER="operations@pdmi.com"
ZIP_PROG="/bin/gzip"
SQL_FNAME="CHKRUNCLMS"
OUTDIR="/usr/lnk/tmp"
TR_ERR=0
DATE=`date -d "yesterday 0800" +%Y%m%d`
AWS_DIR2="/usr/lnk/wt/oper-wt/CLAIM72PDM"
AWS_DIR="s3://ga-internal-transfers-dev/PDMI/Extracts/"
AWS_CP="/usr/local/bin/aws s3 cp"
AWS_CP_OPTS="--only-show-errors"
CLWRK="/usr/lnk/tmp/CLWRK00MAS.chk"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk-whclaims.sh 

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
	cp ${FNAME}.gz ${AWS_DIR2}
	${AWS_CP} ${FNAME}.gz ${AWS_DIR} ${AWS_CP_OPTS}
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

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

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
	CLWRK=$1
	;;
  esac
  shift
done


# Parse environment variables
#parse_env

${SHELL_DIR}/claim72pdm.sh -c ${CYCLE} -r "${BATCHRNGE}${OUTDIR}/${SQL_FNAME}       " -f ${CLWRK} > ${RPT_DIR}/${CYCLE}-claim72pdm 2>&1
if test $? -ne 0
then
	echo "Error with claim72pdm process"
	exit 3
fi
REC_CNT=`wc -l ${OUTDIR}/${SQL_FNAME} | awk '{ print $1 }'`
mv ${OUTDIR}/${SQL_FNAME} ${OUTDIR}/${SQL_FNAME}-${DATE}
FNAME=${OUTDIR}/${SQL_FNAME}-${DATE}
file_transfer

if [ $TR_ERR != 0 ]
then
        echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "Check Run Claims" ${MAIL_OPER}
fi

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/chk-claim72pdm | ps2pdf - ${RPT_DIR}/chk-claim72pdm.pdf
echo "Output from chk-whclaims.sh process" | ${MAIL_PROG} -s "Check Run - chk-whclaims" ${MAIL_OPER} -a ${RPT_DIR}/chk-claim72pdm.pdf

date

exit 0
