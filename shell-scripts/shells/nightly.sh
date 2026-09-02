#!/bin/ksh
#
# Program Name	: nightly.sh
# Description	: Nightly Processing Scripts
# Author	: Linda S. Jefferis
# Date		: 10/31/96
# Modifications : 11/25/97 (LSJ) Added -t option to run of audit01.sh
#		: 03/13/01 (LSJ) Added subject line to mail
#		: 05/02/05 (LSJ) Added 'wc -l' email to warehouse
#		: 10/26/2005 (LSJ) Changes for Linux
#		: 10/27/2009 (LSJ) Added logic for copying ??.* files to COLO
#		: 01/09/2010 (LSJ) Changes for new production site
#		: 06/13/2012 (LSJ) Add rv601_process.sh
#		: 05/30/2013 (LSJ) Changes/Additions for zippass.sh logic
#		: 5/31/2016 - TT3454-39 add webclaim file move logic
#		: 09/05/2017 - TT17572-4 copy to Prod20 procedure under zipfiles
#		: 09/19/2017 - Changed OH_DIR and added NC_DIR and scp
#		: 08/27/2018 - added auditfile-counts files
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_ZIP=operations@pdmi.com
MAIL_WHSE=warehouse@pdmi.com
DATE=`date -d "yesterday" +%Y%m%d`
EXPORT_DIR=/usr/lnk/sqlimports/audit
ZIP_PROG="/usr/lnk/shell/zippass.sh -m"
AUD_DIR=/usr/lnk/audit
OH_DIR="prod20:/usr/lnk/repl/server/prod10/auditfiles"
NC_DIR="prod11:/usr/lnk/repl/server/prod10/auditfiles"
HOST=`/usr/lnk/shell/get_hostname.sh`

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
	scp -q auditfiles-${DATE}.zip ${OH_DIR}/${HOST}-auditfiles-${DATE}.zip
	scp -q auditfiles-${DATE}.zip ${NC_DIR}/${HOST}-auditfiles-${DATE}.zip
}

#
# Main routine
#

echo Nightly Processing Scripts
date

for webfile in `ls -1 /tmp/lines/webclaim`
do
     mv /tmp/lines/webclaim/$webfile /usr/lnk/daily/webclaim/$webfile-${DATE}
done
${SHELL_DIR}/audit_mv.sh 2>&1 | ${MAIL_PROG} -s "audit_mv.sh" ${MAIL_ZIP}
${SHELL_DIR}/audit01.sh -t all 2>&1 | ${MAIL_PROG} -s "audit01.sh" ${MAIL_ZIP}
zip_audit01
${SHELL_DIR}/audit_zip.sh 2>&1 | ${MAIL_PROG} -s "audit_zip.sh" ${MAIL_ZIP}
${SHELL_DIR}/rv601_process.sh 2>&1 | ${MAIL_PROG} -s "rv601_process.sh" ${MAIL_ZIP}
zipfiles

date

exit 0
