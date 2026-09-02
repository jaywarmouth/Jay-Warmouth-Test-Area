#!/bin/sh
#
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_ZIP=operations@pdmi.com
DATE=`date -d "yesterday" +%Y%m%d`
ZIP_PROG="/usr/lnk/shell/zippass.sh -mj"
AUD_DIR=/usr/lnk/audit
AUD_ARCH=/usr/lnk/audit/archive
HOST=`/usr/lnk/shell/get_hostname.sh`
CLEANUP_CMD="/usr/lnk/shell/clean_dir.sh"
CLEANUP_DAYS=30

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: QA_audit_daily.sh 

ENDOFUSAGE
  exit 1
}


# Zip all previous day's audit files
zipfiles()
{
        cd ${AUD_DIR}
        ${ZIP_PROG} ${AUD_ARCH}/auditfiles-${DATE}.zip *${DATE}*
}

#
# Main routine
#

date

/usr/local/bin/arch_webclaimfiles.sh > /tmp/.arch_webclaimfiles.log.$$ 2>&1
${CLEANUP_CMD} ${AUD_ARCH} ${CLEANUP_DAYS}
${SHELL_DIR}/QA_audit_mv.sh > /tmp/.QAaudit_mv.log.$$ 2>&1
${SHELL_DIR}/apilog_mv.sh > /tmp/.apilog_mv.log.$$ 2>&1
zipfiles

date

exit 0
