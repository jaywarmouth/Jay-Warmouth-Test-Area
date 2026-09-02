#!/bin/sh
#

RETVAL=0
SHELL_DIR=/usr/lnk/shell
RPT_DIR=/usr/lnk/rpt
ERR_FILE=/tmp/script02-errs.txt
MAIL_PROG=/usr/bin/mutt
MAIL_T0="operations@pdmi.com"
PATH=/usr/rmcobol:$PATH
SWITCH=$1

${SHELL_DIR}/script02.sh -r ${SWITCH} > ${RPT_DIR}/script02 2>&1

grep "ERROR" ${RPT_DIR}/script02 > ${ERR_FILE}
if test -s ${ERR_FILE} 
then
	${MAIL_PROG} -s "${HOSTNAME} - Weekly script02 ERRORS" ${MAIL_T0} < ${RPT_DIR}/script02
fi

