#!/bin/sh
#
# Program Name	: chk-claim105.sh
# Description	: Check Run claim105 Procedure
# Author	: Linda S. Jefferis
# Date		: 02/23/2005
# Modifications : 02/10/2011 - Added logic for dev10
#		: 08/20/2011 - Temporarily commented out special logic for dev10
#		: 08/13/2018 - TT13915-69
#		: 04/26/2022 - Changes for Prod20(BACKUP2_SERVER) decommission
#		: 07/21/2022 - enhancements changes
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
CLWRK="/usr/lnk/tmp/CLWRK00MAS.chk"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk-claim105.sh

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

case ${HOSTNAME} in
   "${PROD_SERVER}")
	${SHELL_DIR}/claim105.sh -i ${CLWRK} -m > ${RPT_DIR}/chk-claim105 2>&1
	;;
   "${BACKUP1_SERVER}" | "${TEST1_SERVER}")
	scp -q ${PROD_SERVER}:${CLWRK} /usr/lnk/tmp
	${SHELL_DIR}/claim105.sh -i ${CLWRK} -m > ${RPT_DIR}/chk-claim105 2>&1
        rm -f ${CLWRK}
        ;;
esac
cat ${RPT_DIR}/chk-claim105 | ${MAIL_PROG} -s "${HOSTNAME} - Claim105 Update" ${MAIL_TO}

exit 0
