#!/bin/sh
#
# Program Name	: rebate_esi_file.sh
# Description	: Procedure to prepare file and email notification
#		  Command Line Arguments:
#		  -p <ccyymm>  File date
# Author	: Linda S. Jefferis
# Date		: 02/20/2014
#		: 2/4/2015 - Add rbesi001.sh processes.
#		: 5/8/2015 - Add RBESI250-SUMMARY file logic (TT:8864-14)
#		: 12/09/2015 - TT8864-20 logic for new system summary file.
#		: 05/09/2016 - TT12142-4; new REMSG00RPT report file
#		: 09/26/2017 - TT8864-59
#		: 12/04/2017 - Add clinicalsupport@pdmi.com email address
#		: 10/16/2018 - Add dhomoly@pdmi.com
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_DIR="/usr/lnk/wt/oper-wt/rebateinfo"
TR_DIR="/usr/lnk/wt/oper-wt/ESIRebates"
AWS_DIR="/usr/lnk/wt/oper-wt/ESIRebates-AWS"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
SUMM_PARAM="/usr/lnk/log/rbesi001_rebate_parm_summary_all.txt"
MAILRPTTO="operations@pdmi.com"
#MAILRPTTO="clinicalsupport@pdmi.com pvoytilla@pdmi.com"
SUMMRPT_DIR="/usr/lnk/wt/oper-wt/rebateinfo"
WT_DIR1=/usr/lnk/wt/pvoytil
WT_DIR2=/usr/lnk/wt/rpavelick
WT_DIR3=/usr/lnk/wt/cpezzulo
REBREV_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebate_esi_file.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	REB_FILE="RB-ESI-${PE_DATE}"
	REBREV_FILE="RB-ESI-REV-${PE_DATE}"
	SUMMRPT="${SUMMRPT_DIR}/RBESI001-SUMMARY-${PE_DATE}.csv"
	REVSUMMRPT="${SUMMRPT_DIR}/RBESI001-REVSUMMARY-${PE_DATE}.csv"
	RBESI2500_SUMMARY=${SUMMRPT_DIR}/RBESI-2500-GROUP-SUMMARY-${PE_DATE}.csv
	RBESI2500_SYSTEMSUMMARY=${SUMMRPT_DIR}/RBESI-2500-SYSTEM-SUMMARY-${PE_DATE}.csv
	RBESI2500_MESSAGES=${SUMMRPT_DIR}/RBESI-2500-MESSAGES-${PE_DATE}.csv
}

#
rbrev_record_count()
{
          REC_CNT2=`wc -l ${FILE_LOC}/${REBREV_FILE} | awk '{print $1}'`
}

#
# Copy files
rbrev_copy_files()
{
	cp ${FILE_LOC}/${REBREV_FILE} ${TR_DIR}
	cp ${FILE_LOC}/${REBREV_FILE} ${AWS_DIR}
        cp ${FILE_LOC}/${REBREV_FILE} ${TMP_DIR}
        FNAME=${TMP_DIR}/${REBREV_FILE}
        file_transfer
        echo -e "The rebate file, ${REB_FILE}, has been uploaded. \rThe Record Count (including header and trailer records) = ${REC_CNT2}." | ${MAIL_PROG} -s "PDMI-ESI Rebate Reversal File Notification" ${MAIL_TO}
}

#
record_count()
{
	  REC_CNT=`wc -l ${FILE_LOC}/${REB_FILE} | awk '{print $1}'`
}

#
# Copy files
copy_files()
{
	cp ${FILE_LOC}/${REB_FILE} ${TR_DIR}
	cp ${FILE_LOC}/${REB_FILE} ${AWS_DIR}
	cp ${FILE_LOC}/${REB_FILE} ${TMP_DIR}
	FNAME=${TMP_DIR}/${REB_FILE}
	file_transfer	
 	echo -e "The rebate file, ${REB_FILE}, has been uploaded. \rThe Record Count (including header and trailer records) = ${REC_CNT}." | ${MAIL_PROG} -s "PDMI-ESI Rebate File Notification" ${MAIL_TO}
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

#
# Email File Summary
email_summaryinfo()
{
	if [ ${REBREV_FLG} = 1 ]
	then
		echo "See attached ESI summary/detail reports." | ${MAIL_PROG} -s "ESI Rebate File Summary/Detail Reports" ${MAILRPTTO} -a ${SUMMRPT} -a ${REVSUMMRPT} -a ${RBESI2500_SUMMARY} -a ${RBESI2500_SYSTEMSUMMARY}
	else
		echo "See attached ESI summary/detail reports." | ${MAIL_PROG} -s "ESI Rebate File Summary/Detail Reports" ${MAILRPTTO} -a ${SUMMRPT} -a ${RBESI2500_SUMMARY} -a ${RBESI2500_SYSTEMSUMMARY}
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
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	PE_DATE=$1
	;;
  esac
  shift
done

set_filenames

if ! test -s ${FILE_LOC}/${REB_FILE}
then
	echo "-*> Rebate file, ${FILE_LOC}/${REB_FILE}, does not exist..."
	exit 99
fi

if test -s ${FILE_LOC}/${REBREV_FILE}
then
        REBREV_FLG=1
fi

echo
echo "--> Run rbesi001 and email summary"
if [ ${REBREV_FLG} = 1 ]
then
	${SHELL_DIR}/rbesi001.sh -f ${FILE_LOC}/${REBREV_FILE} -p ${SUMM_PARAM} -o ${REVSUMMRPT} > ${RPT_DIR}/rbmon-rbesi001 2>&1
	${SHELL_DIR}/rbesi001.sh -f ${FILE_LOC}/${REB_FILE} -p ${SUMM_PARAM} -o ${SUMMRPT} >> ${RPT_DIR}/rbmon-rbesi001 2>&1
else
	${SHELL_DIR}/rbesi001.sh -f ${FILE_LOC}/${REB_FILE} -p ${SUMM_PARAM} -o ${SUMMRPT} > ${RPT_DIR}/rbmon-rbesi001 2>&1
fi

email_summaryinfo

cp ${RBESI2500_MESSAGES} ${WT_DIR1}
cp ${RBESI2500_MESSAGES} ${WT_DIR2}
cp ${RBESI2500_MESSAGES} ${WT_DIR3}

if [ ${REBREV_FLG} = 1 ]
then
	echo 
	echo "--> Determine REBREV record count..."
	echo
	rbrev_record_count
	echo "--> Copying REBREV file..."
	echo
	rbrev_copy_files
fi

echo
echo "--> Determine REBATE record count..."
echo

record_count

echo 
echo "--> Copying REBATE file..."
echo

copy_files


echo "-=> Finished."

exit 0
