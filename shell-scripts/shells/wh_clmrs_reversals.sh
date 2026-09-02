#!/bin/ksh
#
# Program Name	: wh_clmrs_reversals.sh
# Description	: Create restack claims extract files for warehouse
#		  Command Line Arguments:
#		  -d <p/e date - ccyymmdd>
# Author	: Linda S. Jefferis
# Date		: 10/21/2014
# Modifications	: 
#		
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
DATE="null"
OUT_DIR="claims"
SQL_DIR="/usr/lnk/wt/sqlimports"
MAIL_PROG="/usr/bin/mutt"
MAIL_OPER="operations@pdmi.com"
MAIL_WHSE="warehouse@pdmi.com"
ZIP_PROG="/bin/gzip"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_clmrs_reversals.sh -d <ccyymmdd>
	where <ccyymmdd> is the current p/e

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
        mv ${FNAME} ${FNAME}-${DATE}
        gzip ${FNAME}-${DATE}
        mv ${FNAME}-${DATE}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${FNAME}"
        fi
else
        echo "${FNAME} does not exist"
fi	
}

# Set Batch Range
set_batch()
{
	BATCH=`${SHELL_DIR}/convert_to_batch.sh ${DATE}`
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
    -d) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	set_batch
	;;
  esac
  shift
done

date

parse_env

echo "--> Running CLMRS claim72pdm"
echo ""
CL72_FILE="/usr/lnk/tmp/CL72R-CLMRS"
${SHELL_DIR}/claim72pdm.sh -c twkrst -r "${BATCH}R004${BATCH}R004${CL72_FILE}      " -f ${CLMRS00MAS} > ${RPT_DIR}/tweek-clmrs 2>&1
if test -s ${CL72_FILE}
then
   mv ${SQLIMPORTS}/${OUT_DIR}/CL72-counts-TR ${SQLIMPORTS}/${OUT_DIR}/CLMRS-X-counts
   FNAME=${SQLIMPORTS}/${OUT_DIR}/CLMRS-X-counts
   file_transfer
   mv ${CL72_FILE} ${SQLIMPORTS}/${OUT_DIR}/CLMRS-X
   FNAME=${SQLIMPORTS}/${OUT_DIR}/CLMRS-X
   file_transfer
   echo "A tweek CLMRS-X-${DATE} is available." | ${MAIL_PROG} -s "Tweek CLMRS" -c ${MAIL_OPER} ${MAIL_WHSE}
fi

a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/tweek-clmrs | ps2pdf - ${RPT_DIR}/tweek-clmrs.pdf

echo "Output from wh_clmrs_reversals.sh process" | ${MAIL_PROG} -a ${RPT_DIR}/tweek-clmrs.pdf -s "Tweek CLMRS Reversals" ${MAIL_OPER}

date

exit 0
