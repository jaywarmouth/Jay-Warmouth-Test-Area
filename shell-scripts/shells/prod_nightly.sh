#!/bin/sh
#
# Program Name	: nightly_prod.sh
# Description	: New RedHat: Nightly Processing Scripts for audit and other daily files.
# Author	: Linda S. Jefferis
# Date		: 02/24/2020
#
# Variables Used:
PATH=/opt/rmcobol:$PATH
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_ZIP=operations@pdmi.com
DATE=`date -d "yesterday" +%Y%m%d`
EXPORT_DIR=/usr/lnk/sqlimports/audit
ZIP_PROG="/usr/lnk/shell/zippass.sh -m"
AUD_DIR=/usr/lnk/audit
NC_DIR="prod11:/usr/lnk/repl/server/prod10/auditfiles"
HOST=`/usr/lnk/shell/get_hostname.sh`
WEBCLAIM_DIR="/usr/local/logs/linedrv/webclaim"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nightly.sh 

ENDOFUSAGE
  exit 1
}

# Zip audit01 files
zip_audit01()
{
	cd ${EXPORT_DIR}
	${ZIP_PROG} audit01files-${DATE}.zip ??-${DATE}* auditfile-counts-${DATE}*
}

# Zip all previous day's audit files
zipfiles()
{
        cd ${AUD_DIR}
        ${ZIP_PROG} auditfiles-${DATE}.zip *${DATE}*
	scp -q auditfiles-${DATE}.zip ${NC_DIR}/${HOST}-auditfiles-${DATE}.zip
}

#
# Main routine
#

echo Nightly Processing Scripts
date

# Move webclaim files
mv ${WEBCLAIM_DIR}/webclaim_general ${WEBCLAIM_DIR}/webclaim_general-${DATE}
mv ${WEBCLAIM_DIR}/webclaim_mcet ${WEBCLAIM_DIR}/webclaim_mcet-${DATE}
mv ${WEBCLAIM_DIR}/webclaim_medsub ${WEBCLAIM_DIR}/webclaim_medsub-${DATE}
mv ${WEBCLAIM_DIR}/webclaim_pricingtool ${WEBCLAIM_DIR}/webclaim_pricingtool-${DATE}
mv ${WEBCLAIM_DIR}/webclaim_restack ${WEBCLAIM_DIR}/webclaim_restack-${DATE}

${SHELL_DIR}/audit_mv.sh 2>&1 | ${MAIL_PROG} -s "audit_mv.sh" ${MAIL_ZIP}
${SHELL_DIR}/audit01.sh -t all 2>&1 | ${MAIL_PROG} -s "audit01.sh" ${MAIL_ZIP}
zip_audit01
${SHELL_DIR}/audit_zip.sh 2>&1 | ${MAIL_PROG} -s "audit_zip.sh" ${MAIL_ZIP}
${SHELL_DIR}/rv601_process.sh 2>&1 | ${MAIL_PROG} -s "rv601_process.sh" ${MAIL_ZIP}
zipfiles

date

exit 0
