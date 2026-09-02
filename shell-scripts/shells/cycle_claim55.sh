#!/bin/sh
#
# Program Name	: cycle_claim55.sh
# Description	: Runs claim55.sh and claim56.sh
#                 Command line arguments:
#		  -c <pay|twice|week|tweek>
#		  -d <p/e - ccyymmdd>
# Author	: Linda S. Jefferis
# Date		: 06/07/2010
# Modifications : 01/07/2011 - Removed special logic for "STORM" warehouse file.
#               : 04/05/2011 - Added PDF conversion and email of claim55 output file.
#		: 1/7/2014 - removed cla55_rbextract flexgen process and replaced with claim56.sh (TT #4534-5)
#		: 11/12/2019 - Change "a2ps" to "enscript"
#		: 05/26/2020 - Add AWS_DIR variable and file copy to location (CC: 10194;DME)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_WHSE="DEDMSupport@pdmi.onmicrosoft.com"
MAIL_OPER="operations@pdmi.com"
FLEX="/usr/lnk/flexgen"
DATE="null"
CYCLE="null"
TR_ERR=0
ZIP_PROG="/bin/gzip"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
AWS_DIR2="/usr/lnk/wt/oper-wt/CLAIM55"
AWS_DIR="s3://ga-internal-transfers/PDMI/Extracts/"
AWS_CP="/usr/local/bin/aws s3 cp"
AWS_CP_OPTS="--only-show-errors"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cycle_claim55.sh -d <p/e - ccyymmdd>

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
# Set Filenames
set_filenames()
{
   case ${CYCLE} in
     "pay")
	CYC_LET="P"
	MAIL_SUBJ="PAY_CYCLE CLAIM55"
	;;
     "twice")
	CYC_LET="T"
	MAIL_SUBJ="TWICE_CYCLE CLAIM55"
	;;
     "week")
	CYC_LET="W"
	MAIL_SUBJ="WEEK_CYCLE CLAIM55"
	;;
     "tweek")
	CYC_LET="X"
	MAIL_SUBJ="TWEEK-CYCLE CLAIM55"
	;;
     *) usage
	;;
   esac
   CLA55_FNAME="CLAIM55-$CYC_LET"
}

#
# Transfer file
file_transfer()
{
if test -s ${FNAME}
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
	TR_ERR=1
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        ;;
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

if [ $CYCLE = "null" ]
then
	usage
fi

parse_env

set_filenames

WH_CLA55=${SQLIMPORTS}/${OUT_DIR}/${CLA55_FNAME}-${DATE}
CLAIM55MAS=/usr/lnk/tmp/CLAIM55MAS.${CYCLE}; export CLAIM55MAS

echo "--> Updating CLAIM55MAS"
date

${SHELL_DIR}/claim55.sh -c ${CYCLE} -m -y -f ${CLAIM55MAS} > ${RPT_DIR}/${CYCLE}-claim55 2>&1

# Convert claim55 output to PDF and email
enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/${CYCLE}-claim55 | ps2pdf - ${RPT_DIR}/${CYCLE}-claim55.pdf
echo "Output from ${CYCLE}-claim55 process" | ${MAIL_PROG} -s "${CYCLE}-cycle - claim55" ${MAIL_OPER} -a ${RPT_DIR}/${CYCLE}-claim55.pdf 


echo "--> Creating CLAIM55 extract file"
${SHELL_DIR}/claim56.sh -i ${CLAIM55MAS} -o ${WH_CLA55} > ${RPT_DIR}/${CYCLE}-claim56 2>&1

FNAME=${WH_CLA55}
file_transfer

if [ $TR_ERR = 0 ]
then
	echo "The ${CYCLE} CLAIM55 extract file is now available for updating to the warehouses." | ${MAIL_PROG} -s "${MAIL_SUBJ}" -c ${MAIL_OPER} ${MAIL_WHSE}
else
	echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "${CYCLE} CLAIM55" ${MAIL_OPER}
fi

date

exit 0
