#!/bin/sh
#
# Program Name	: daily_audit_check.sh
# Description	: Comparison of end of day audit files on backup system to rook
# Author	: Linda S. Jefferis
# Date		: 01/03/2006
# Modifications : 11/03/2008 - Adding error checking logic  (LSJ)
#		: 11/17/2008 - Added audit-cmp-colo.sh logic for s1rook  (LSJ)
#		: 11/21/2008 - Added "cd /usr/lnk/rpt" and fixed "find" command  (LSJ)
#		: 11/23/2009 - Added "prod11" to audit-cmp-colo.sh logic  (LSJ)
#		: 01/09/2010 - Changed audit-cmp-colo.sh to run for Rook
#		: 03/08/2012 - Removed audit-cmp-colo.sh logic
#
# Variables Used:
PATH=/usr/rmcobol:$PATH
SHELL_DIR="/usr/lnk/shell"
TSTSHL_DIR="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_audit_check.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

cd /usr/lnk/rpt
find . -name "audit-cmp.*" -mtime +7 -exec rm {} \;
${SHELL_DIR}/audit-cmp.sh > ${RPT_DIR}/audit-cmp 2>&1

grep "Files not equal" ${RPT_DIR}/audit-cmp > /dev/null
if test $? -ne 0
then
	cat ${RPT_DIR}/audit-cmp | ${MAIL_PROG} -s "${HOSTNAME}:audit-cmp" ${MAIL_TO}
else
	grep "Files were equal" ${RPT_DIR}/audit-cmp > /tmp/audit-cmp
	grep "Files not equal" ${RPT_DIR}/audit-cmp >> /tmp/audit-cmp
	echo "" >> /tmp/audit-cmp	
	echo "ERROR Count:  `grep "ERROR" ${RPT_DIR}/audit-cmp | wc -l`" >> /tmp/audit-cmp
	echo "" >> /tmp/audit-cmp
	echo "Number of Claims WRITTEN:  `grep " WRITTEN" ${RPT_DIR}/audit-cmp | wc -l`" >> /tmp/audit-cmp
	echo "Number of Claims REWRITTEN:  `grep "REWRITTEN" ${RPT_DIR}/audit-cmp | wc -l`" >> /tmp/audit-cmp
	echo "Number of CMG Claims Processed:  `grep "CMG CLAIM:" ${RPT_DIR}/audit-cmp | wc -l`" >> /tmp/audit-cmp
	cat /tmp/audit-cmp | ${MAIL_PROG} -s "${HOSTNAME}:audit-cmp" ${MAIL_TO}
fi

bak ${RPT_DIR}/audit-cmp

exit 0
