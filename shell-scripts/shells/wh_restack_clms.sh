#!/bin/ksh
#
# Program Name	: wh_restack_clms.sh
# Description	: Create restack claims extract files for warehouse
#		  Command Line Arguments:
#		  -d <restack date - ccyymmdd>
# Author	: Linda S. Jefferis
# Date		: 02/03/2013
# Modifications	: 01/24/2014 - Added RESTACK_DIR logic
#		: 5/22/2015 - add email notifcation to warehouse that files are available.(TT:13731-2) (DME)
#		: 5/29/2015 - change date to dispaly current date as ccyymmdd and update Date code check to work if a date is entered. (DME)
#		: 3/22/2016 - TT15378-3
#		
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/tmp"
DATE=`date +%Y%m%d`
OUT_DIR="claims"
SQL_DIR="/usr/lnk/wt/sqlimports"
MAIL_PROG="/usr/bin/mutt"
MAIL_OPER="operations@pdmi.com"
MAIL_WH="warehouse@pdmi.com"
MAIL_TEXT="${FILE_PATH}/restack_clms.txt"
TR_ERR=0
ZIP_PROG="/bin/gzip"
CYCLE="rst"
EXT_DATE=`date -d "yesterday" +%Y%m%d`
RESTACK_DIR=husk:/usr/lnk/shares/ftp-tmp/restack


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_restack_clms.sh -d <restack date - ccyymmdd>

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
        mv ${FNAME} ${FNAME}-${EXT_DATE}
	scp ${FNAME}-${EXT_DATE} ${RESTACK_DIR}
        gzip ${FNAME}-${EXT_DATE}
        mv ${FNAME}-${EXT_DATE}.gz ${SQL_DIR}/${OUT_DIR}
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

#Email Notification to Warehouse
wh_email()
{

echo "The following restack files are available: " > ${MAIL_TEXT}
echo "" >> ${MAIL_TEXT}

cd ${SQL_DIR}/${OUT_DIR}
if [ ! -f CLWRK-${EXT_DATE}.gz -o ! -f CLWRK-counts-${EXT_DATE}.gz -o ! -f CLMRS-${EXT_DATE}.gz -o ! -f CLMRS-counts-${EXT_DATE}.gz ];
then
        echo "files not available."
        exit 99
else
        ls -1 CLWRK-${EXT_DATE}.gz CLWRK-counts-${EXT_DATE}.gz CLMRS-${EXT_DATE}.gz CLMRS-counts-${EXT_DATE}.gz >> ${MAIL_TEXT}
	cat ${MAIL_TEXT} | ${MAIL_PROG} -s "Restack_files" -c ${MAIL_OPER} ${MAIL_WH}
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

date

parse_env

set_batch

echo "--> Running CLMRS claim72pdm"
echo ""
CL72_FILE="/usr/lnk/tmp/CL72-CLMRS"
${SHELL_DIR}/claim72pdm.sh -c rst -r "${BATCH}A000${BATCH}Z999${CL72_FILE}       " -f ${CLMRS00MAS} > ${RPT_DIR}/rst-clmrs 2>&1
mv ${SQLIMPORTS}/${OUT_DIR}/CL72-counts-R ${SQLIMPORTS}/${OUT_DIR}/CLMRS-counts
FNAME=${SQLIMPORTS}/${OUT_DIR}/CLMRS-counts
file_transfer
mv ${CL72_FILE} ${SQLIMPORTS}/${OUT_DIR}/CLMRS
FNAME=${SQLIMPORTS}/${OUT_DIR}/CLMRS
file_transfer
a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/rst-clmrs | ps2pdf - ${RPT_DIR}/rst-clmrs.pdf

echo "--> Running CLWRK claim72pdm"
echo ""
CL72_FILE="/usr/lnk/tmp/CL72-CLWRK"
${SHELL_DIR}/claim72pdm.sh -c rst -r "LA01A000${BATCH}Z999${CL72_FILE}       " -f /usr/lnk/restack/CLWRK00RST > ${RPT_DIR}/rst-clwrk 2>&1
mv ${SQLIMPORTS}/${OUT_DIR}/CL72-counts-R ${SQLIMPORTS}/${OUT_DIR}/CLWRK-counts
FNAME=${SQLIMPORTS}/${OUT_DIR}/CLWRK-counts
file_transfer
mv ${CL72_FILE} ${SQLIMPORTS}/${OUT_DIR}/CLWRK
FNAME=${SQLIMPORTS}/${OUT_DIR}/CLWRK
file_transfer

wh_email

a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/rst-clwrk | ps2pdf - ${RPT_DIR}/rst-clwrk.pdf

echo "Output from wh_restack_clms.sh process" | ${MAIL_PROG} -a ${RPT_DIR}/rst-clmrs.pdf -a ${RPT_DIR}/rst-clwrk.pdf -s "Restack Claims" ${MAIL_OPER}

scp ${RPT_DIR}/rst-clmrs ${RESTACK_DIR}
scp ${RPT_DIR}/rst-clwrk ${RESTACK_DIR}

date

exit 0
