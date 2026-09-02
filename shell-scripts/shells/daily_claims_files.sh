#!/bin/sh
#
# Program Name	: daily_claims_files.sh
# Description	: runs daily claim111d0 and related procedures
# Author	: Linda Jefferis
# Date		: 07/13/2005
# Modifications : 10/26/2005 - Changes for Linux  (LSJ)
#		: 12/28/2007 - Added claim111rx procedure  (LSJ)
#		: 08/18/2009 - Changed subject for email  (LSJ)
#		: 12/29/2011 - Changed claim11 process to claim111d0
#		: 05/11/2012 - Added daily_meritain.sh process
#		: 07/02/2012 - Added daily_trx_pba.sh process
#		: 07/05/2012 - Removed daily_trx_pba.sh process
#		: 07/26/2013 - Added dailyclms_ahf.sh and removed daily_php.sh
#		: 09/06/2013 - removed notation for running claim111rx.sh and rxeob.sh (DME)		
#		: 09/11/2013 - changed rpt names, added conversion to PDF and email of PDF attachments.  (LSJ)
#		: 05/12/2014 - Moved daily_naa.sh process to end.
#		: 08/05/2014 - Changed order transfer processes and added daily_LBRXhealthsmart.sh.
#		: 12/9/2014 - As per email from Benefits, cancel the daily_naa.sh until further notice.
#		: 1/9/2015 - Removed daily_cypress.sh process (TT #12780-2)
#		: 03/12/2015 - Added cleanup of files that are created but not transfered anywhere (LSJ)
#		: 03/12/2015 - Removed daily_meritain.sh process (LSJ)
#		: 03/18/2015 - Fix "cleanup" logic; added "cd ${TAPE_DIR}"
#		: 05/11/2015 - Remove LBRXHealthsmart file distribution (TT:13484-6)
#		: 03/26/2018 - TT17429-24; Added LASH (sys0080) file to inactive archive.
#		: 07/31/2018 - TT17486-69; remove AHF inactive process.
#		: 01/10/2020 - Change "a2ps" to "enscript"

# Variables Used:
PATH=/opt/rmcobol:$PATH
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
LOG="/tmp/daily_claims_files.log"
DAY=`date +%w`
TAPE_DIR="/usr/lnk/tapes"
DATE=`date +%Y%m%d`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_claims_files.sh 

ENDOFUSAGE
  exit 1
}

#
# Cleanup
cleanup()
{
	cd ${TAPE_DIR}
	zip -mj inactive-claim111d0-${DATE}.zip ???CL111DAYD0-?-CDB ???CL111DAYD0-?-CKM ???CL111DAYD0-?-MRTN ???CL111DAYD0-?-LRBS ???CL111DAYD0-?-VTX ???CL111DAYD0-P-HSMT ???CL111DAYD0-?-LASH ???CL111DAYD0-?-AHF ???CL111DAYD0-P-LVID ???CL111DAYD0-P-ACR
	mv inactive-claim111d0-${DATE}.zip /usr/lnk/rptarch/daily
}

#
# Main routine
#

umask 002


echo `date` > ${LOG}
echo "--> Starting Daily Claim111 (LASH) procedure" >> ${LOG}
${SHELL_DIR}/claim111d0.sh -c day > ${RPT_DIR}/claim111d0-dly 2>&1
echo "--> Claim111 has completed" >> ${LOG}
echo "" >> ${LOG}
echo `date` >> ${LOG}

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/claim111d0-dly | ps2pdf - ${RPT_DIR}/claim111d0-dly.pdf

echo "--> Starting Daily Claim111rx (RXEOB) procedure" >> ${LOG}
${SHELL_DIR}/claim111rx.sh -c day > ${RPT_DIR}/claim111rx-dly 2>&1
echo "--> Claim111rx has completed" >> ${LOG}
echo "" >> ${LOG}
echo `date` >> ${LOG}

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/claim111rx-dly | ps2pdf - ${RPT_DIR}/claim111rx-dly.pdf

${SHELL_DIR}/daily_lash.sh >> ${LOG} 2>&1

${SHELL_DIR}/rxeob.sh >> ${LOG} 2>&1

cleanup

cat /tmp/daily_claims_files.log | ${MAIL_PROG} -s "Prod10 - Daily Claims Process" ${MAIL_TO} -a ${RPT_DIR}/claim111d0-dly.pdf -a ${RPT_DIR}/claim111rx-dly.pdf 

exit 0
