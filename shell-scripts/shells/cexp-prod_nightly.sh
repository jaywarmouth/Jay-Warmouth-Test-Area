#!/bin/sh
#
# Program Name	: cexp-prod_nightly.sh
# Description	: New RedHat: Nightly Processing Scripts for audit and other daily files.
#
# Variables Used:
PATH=/opt/rmcobol:$PATH
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_ZIP=operations@pdmi.com
DATE=`date +%Y%m%d`
DATE2=`date -d "yesterday" +%Y%m%d`
EXPORT_DIR=/usr/lnk/sqlimports/audit
ZIP_PROG="/usr/lnk/shell/zippass.sh -m"
AUD_DIR=/usr/lnk/audit/backup

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
	${ZIP_PROG} audit01files-priorcexp-${DATE}.zip ??-${DATE2}* auditfile-counts-${DATE2}*
}


#
# Main routine
#

echo CEXP Audit Processing Scripts
date


${SHELL_DIR}/cexp-audit_mv.sh 2>&1 | ${MAIL_PROG} -s " CEXP audit_mv.sh" ${MAIL_ZIP}
${SHELL_DIR}/cexp-audit01.sh -t all 2>&1 | ${MAIL_PROG} -s "CEXP audit01.sh" ${MAIL_ZIP}
zip_audit01
${SHELL_DIR}/cexp-audit_zip.sh 2>&1 | ${MAIL_PROG} -s "CEXP audit_zip.sh" ${MAIL_ZIP}

date

exit 0
