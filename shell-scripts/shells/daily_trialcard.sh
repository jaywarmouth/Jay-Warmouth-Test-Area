#!/bin/sh
#
# Program Name	: daily_trialcard.sh
# Description	: Daily TrialCard Processing 
#		  Currently cardh78 and tcndc01
# Author	: Linda S. Jefferis
# Date		: 06/09/2010
# Modifications : 07/19/2011 - Added logic for different Sunday run time
#		: 12/09/2011 - Changed output directory for TCNDC file to /usr/lnk/wt/sqlimports/misc
#		: 08/20/2012 - Removed cardh78.sh logic
#		: 03/10/2016 - TT13309-6
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO=operations@pdmi.com
CURR_DATE=`date +%Y%m%d`
DATE=`date -d "yesterday 0800" +%Y%m%d`
DAY=`date +%w`
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
TCNDC_OUT_DIR=/usr/lnk/wt/sqlimports/misc
FILE_DIR="/usr/lnk/tapes"
ARCH_DIR="/usr/lnk/elig_in_1/sys0078"
TCNDC01_FILE="TCNDC-${DATE}"
LOG="$RPT_DIR/daily_trialcard"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_trialcard.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

#${SHELL_DIR}/cardh78.sh > ${LOG} 2>&1
#FILE=${CARDH78_FILE}
#TR_SCRIPT="${SHELL_DIR}/tr_cardh78.sh"
#TIME=`date +%M`
#cp_file


${SHELL_DIR}/tcndc01.sh > ${LOG} 2>&1 
FILE=${TCNDC01_FILE}
TR_SCRIPT="${SHELL_DIR}/tr_tcndc01.sh"
TIME=`date +%M`
if test -s ${FILE_DIR}/${FILE}
then
	cp ${FILE_DIR}/${FILE} ${TCNDC_OUT_DIR}
	if [ ${DAY} = 0 ]
        then
                ssh ${REMOTE_SYS} "echo "${TR_SCRIPT}" | at 10:${TIME}am today"
        else
                ssh ${REMOTE_SYS} "echo "${TR_SCRIPT}" | at 6:${TIME}am today"
        fi
        echo "File archived to ${ARCH_DIR}" >> ${LOG}
        mv ${FILE_DIR}/${FILE} ${ARCH_DIR}
else
        echo "-*> No ${FILE} file..." >> ${LOG}
fi

cat ${LOG} | ${MAIL_PROG} -s "Daily Trial Card Processes" ${MAIL_TO}


exit 0
