#!/bin/ksh
#
# Program Name	: daily_proc.sh
# Description	: Runs daily claim111 and related procedures
# Author	: Linda Jefferis
# Date		: 07/13/2005
# Modifications : 10/26/2005 - Changes for Linux  (LSJ)
#		: 12/28/2007 - Added claim111rx procedure  (LSJ)
#		: 08/18/2009 - Changed subject for email  (LSJ)
#		: 12/29/2011 - Changed claim11 process to claim111d0
#		: 05/11/2012 - Added daily_meritain.sh process
#		: 07/02/2012 - Added daily_trx_pba.sh process
#		: 07/05/2012 - Removed daily_trx_pba.sh process
#		: 01/30/2013 - Remove Claim111d0 process (DME)
#		: 01/30/2013 - Added claim111.dly to log (DME)
#
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
LOG="/tmp/dly_proc.log"
DAY=`date +%w`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_proc.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

umask 002

echo `date` > ${LOG}
echo "--> Starting Daily Claim111rx (RXEOB) procedure" >> ${LOG}
echo "" >> ${LOG}
${SHELL_DIR}/claim111rx.sh -c day > ${RPT_DIR}/claim111rx.dly 2>&1
echo "--> Claim111rx has completed" >> ${LOG}
echo "" >> ${LOG}
cat ${RPT_DIR}/claim111rx.dly >> ${LOG}
echo "" >> ${LOG}
echo `date` >> ${LOG}
echo "" >> ${LOG}

${SHELL_DIR}/rxeob.sh >> ${LOG}  2>&1

${MAIL_PROG} -s "HUSK - DAILY FILE PROCESS" ${MAIL_TO} < ${LOG}

exit 0
