#!/bin/sh
#
# Program Name	: daily_aultcare_medd_reports.sh
# Description	: Twice-daily process to create Aultcare-MEDD ".csv" files
# Author	: Linda S. Jefferis
# Date		: 12/31/2012
# Modifications : 02/12/2013 - Added "klegg@pdmi.com" as per TT #3244-4
#		: 01/08/2014 - Added medd-wt to file copies (DME)
#		: 05/23/2014 - Added logic for ohclapc045 process (TT #10923-16)
#		: 05/27/2014 - Added/Changed logic for all new HET/CMS reports (TT #10923-29)
#		: 05/29/2014 - Fixed HET email command and removed MAIL_CC (LSJ)
#		: 06/10/2014 - Added ohclapc051 process and logic (TT #10923-30)
#		: 08/13/2014 - Remove logic for ohclapc048 process and reports as per TT #10923-52
#		: 12/19/2014 - Add logic for ohclapc052 (TT #10923-76)
#		: 04/27/2015 - update email logic to remove indivual emails and use only groups. (DME)
#		: 11/19/2015 - Remove ault-24 from transfers. (TT:14622-1 DME)
#
#

# Variables Used:
MAIL_PROG="/usr/bin/mutt"
DATE=`date +%Y%m%d-%H%M%S`
SHELL_DIR="/usr/lnk/shell"
TMP_DIR="/usr/lnk/tmp"
WT_DIR="/usr/lnk/wt"
ARCH_DIR="/usr/lnk/elig_in_1/sys0048"
RPT_FILE_1="${TMP_DIR}/clapc037.csv"
RPT_FILE_2="${TMP_DIR}/clapc038.csv"
RPT_FILE_3="${TMP_DIR}/clapc039.csv"
RPT_FILE_4="${TMP_DIR}/clapc040.csv"
RPT_FILE_5="${TMP_DIR}/clapc045.csv"
RPT_FILE_6="${TMP_DIR}/clapc046.csv"
RPT_FILE_7="${TMP_DIR}/clapc047.csv"
RPT_FILE_9="${TMP_DIR}/clapc049.csv"
RPT_FILE_10="${TMP_DIR}/clapc050.csv"
RPT_FILE_11="${TMP_DIR}/clapc051.csv"
RPT_FILE_12="${TMP_DIR}/clapc052.csv"
NEW_RPT_FILE_1="Transition-Paid-${DATE}.csv"
NEW_RPT_FILE_2="Transition-Reject-${DATE}.csv"
NEW_RPT_FILE_3="Prescriber-Paid-${DATE}.csv"
NEW_RPT_FILE_4="Prescriber-Reject-${DATE}.csv"
NEW_RPT_FILE_5="Exceptions-${DATE}.csv"
NEW_RPT_FILE_6="Reject225-${DATE}.csv"
NEW_RPT_FILE_7="PTHP-Reject713-${DATE}.csv"
NEW_RPT_FILE_9="Reject204-${DATE}.csv"
NEW_RPT_FILE_10="Reject638-${DATE}.csv"
NEW_RPT_FILE_11="Reject336-${DATE}.csv"
NEW_RPT_FILE_12="Reject210-${DATE}.csv"
MAIL_TO="partd@pdmi.com"
RSTCK_MAIL="restack@pdmi.com"
ESCL_MAIL="escalationteam@pdmi.com"
WT_OUT_1="ault-10"
WT_OUT_2="ault-93"
WT_OUT_4="medd-wt"
PRESWT_1="ault-10"
PRESWT_3="ault-34"
PRESWT_4="ault-105"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_aultcare_medd_reports.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

date
echo "--> Process starting..."
${SHELL_DIR}/ohclapc037.sh

${SHELL_DIR}/ohclapc038.sh

${SHELL_DIR}/ohclapc039.sh

${SHELL_DIR}/ohclapc040.sh

${SHELL_DIR}/ohclapc045.sh

${SHELL_DIR}/ohclapc046.sh

${SHELL_DIR}/ohclapc047.sh

${SHELL_DIR}/ohclapc049.sh

${SHELL_DIR}/ohclapc050.sh

${SHELL_DIR}/ohclapc051.sh

${SHELL_DIR}/ohclapc052.sh

echo ""
echo "--> renaming files"
mv ${RPT_FILE_1} ${TMP_DIR}/${NEW_RPT_FILE_1}
mv ${RPT_FILE_2} ${TMP_DIR}/${NEW_RPT_FILE_2}
mv ${RPT_FILE_3} ${TMP_DIR}/${NEW_RPT_FILE_3}
mv ${RPT_FILE_4} ${TMP_DIR}/${NEW_RPT_FILE_4}
mv ${RPT_FILE_5} ${TMP_DIR}/${NEW_RPT_FILE_5}
mv ${RPT_FILE_6} ${TMP_DIR}/${NEW_RPT_FILE_6}
mv ${RPT_FILE_7} ${TMP_DIR}/${NEW_RPT_FILE_7}
mv ${RPT_FILE_9} ${TMP_DIR}/${NEW_RPT_FILE_9}
mv ${RPT_FILE_10} ${TMP_DIR}/${NEW_RPT_FILE_10}
mv ${RPT_FILE_11} ${TMP_DIR}/${NEW_RPT_FILE_11}
mv ${RPT_FILE_12} ${TMP_DIR}/${NEW_RPT_FILE_12}


echo ""
echo "--> Distributing Trans files"
cp ${TMP_DIR}/${NEW_RPT_FILE_1} ${WT_DIR}/${WT_OUT_1}
cp ${TMP_DIR}/${NEW_RPT_FILE_1} ${WT_DIR}/${WT_OUT_2}
cp ${TMP_DIR}/${NEW_RPT_FILE_1} ${WT_DIR}/${WT_OUT_4}
cp ${TMP_DIR}/${NEW_RPT_FILE_2} ${WT_DIR}/${WT_OUT_1}
cp ${TMP_DIR}/${NEW_RPT_FILE_2} ${WT_DIR}/${WT_OUT_2}
cp ${TMP_DIR}/${NEW_RPT_FILE_2} ${WT_DIR}/${WT_OUT_4}
echo "Attached are the latest twice-daily Aultcare-MEDD files." | ${MAIL_PROG} -a ${TMP_DIR}/${NEW_RPT_FILE_1} -a ${TMP_DIR}/${NEW_RPT_FILE_2} -s "Aultcare-MEDD Twice-Daily Information" ${MAIL_TO}

echo ""
echo "--> Distributing Prescriber files"
cp ${TMP_DIR}/${NEW_RPT_FILE_3} ${WT_DIR}/${PRESWT_1}
cp ${TMP_DIR}/${NEW_RPT_FILE_3} ${WT_DIR}/${PRESWT_3}
cp ${TMP_DIR}/${NEW_RPT_FILE_3} ${WT_DIR}/${PRESWT_4}
cp ${TMP_DIR}/${NEW_RPT_FILE_3} ${WT_DIR}/${WT_OUT_4}
cp ${TMP_DIR}/${NEW_RPT_FILE_4} ${WT_DIR}/${PRESWT_1}
cp ${TMP_DIR}/${NEW_RPT_FILE_4} ${WT_DIR}/${PRESWT_3}
cp ${TMP_DIR}/${NEW_RPT_FILE_4} ${WT_DIR}/${PRESWT_4}
cp ${TMP_DIR}/${NEW_RPT_FILE_4} ${WT_DIR}/${WT_OUT_4}
echo "Attached are the latest twice-daily Prescriber Validation files." | ${MAIL_PROG} -a ${TMP_DIR}/${NEW_RPT_FILE_3} -a ${TMP_DIR}/${NEW_RPT_FILE_4} -s "Prescriber Validation Twice-Daily Information" ${MAIL_TO}

echo ""
echo "--> Distributing HET files"
echo "Emailing to:  ${RSTCK_MAIL},${MAIL_TO},${ESCL_MAIL}"
echo "Attached are the latest twice-daily PartD/HET reports." | ${MAIL_PROG} -a ${TMP_DIR}/${NEW_RPT_FILE_9} -a ${TMP_DIR}/${NEW_RPT_FILE_10} -s "PartD/HET Twice-Daily Information" ${RSTCK_MAIL},${MAIL_TO},${ESCL_MAIL}

echo ""
echo "--> Distributing CMS-Audit files"
echo "Emailing to:  ${MAIL_TO}"
echo "Uploading to: ${WT_OUT_1}, ${WT_OUT_2}, ${WT_OUT_4}"
cp ${TMP_DIR}/${NEW_RPT_FILE_5} ${WT_DIR}/${WT_OUT_1}
cp ${TMP_DIR}/${NEW_RPT_FILE_5} ${WT_DIR}/${WT_OUT_2}
cp ${TMP_DIR}/${NEW_RPT_FILE_5} ${WT_DIR}/${WT_OUT_4}
cp ${TMP_DIR}/${NEW_RPT_FILE_6} ${WT_DIR}/${WT_OUT_1}
cp ${TMP_DIR}/${NEW_RPT_FILE_6} ${WT_DIR}/${WT_OUT_2}
cp ${TMP_DIR}/${NEW_RPT_FILE_6} ${WT_DIR}/${WT_OUT_4}
cp ${TMP_DIR}/${NEW_RPT_FILE_7} ${WT_DIR}/${WT_OUT_1}
cp ${TMP_DIR}/${NEW_RPT_FILE_7} ${WT_DIR}/${WT_OUT_2}
cp ${TMP_DIR}/${NEW_RPT_FILE_7} ${WT_DIR}/${WT_OUT_4}
cp ${TMP_DIR}/${NEW_RPT_FILE_11} ${WT_DIR}/${WT_OUT_1}
cp ${TMP_DIR}/${NEW_RPT_FILE_11} ${WT_DIR}/${WT_OUT_2}
cp ${TMP_DIR}/${NEW_RPT_FILE_11} ${WT_DIR}/${WT_OUT_4}
cp ${TMP_DIR}/${NEW_RPT_FILE_12} ${WT_DIR}/${WT_OUT_1}
cp ${TMP_DIR}/${NEW_RPT_FILE_12} ${WT_DIR}/${WT_OUT_2}
cp ${TMP_DIR}/${NEW_RPT_FILE_12} ${WT_DIR}/${WT_OUT_4}
cp ${TMP_DIR}/${NEW_RPT_FILE_12} ${WT_DIR}/${PRESWT_3}
echo "Attached are the latest twice-daily CMS Audit reports." | ${MAIL_PROG} -a ${TMP_DIR}/${NEW_RPT_FILE_5} -a ${TMP_DIR}/${NEW_RPT_FILE_6} -a ${TMP_DIR}/${NEW_RPT_FILE_7} -a ${TMP_DIR}/${NEW_RPT_FILE_11} -a ${TMP_DIR}/${NEW_RPT_FILE_12} -s "CMS Audit Twice-Daily Information" ${MAIL_TO}

echo ""
echo "--> Cleanup"
mv ${TMP_DIR}/${NEW_RPT_FILE_1} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_2} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_3} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_4} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_5} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_6} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_7} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_9} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_10} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_11} ${ARCH_DIR}
mv ${TMP_DIR}/${NEW_RPT_FILE_12} ${ARCH_DIR}

echo "-> Process completed."
date


exit 0
