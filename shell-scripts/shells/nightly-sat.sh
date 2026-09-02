#!/bin/ksh
#
# Program Name	: nightly-sat.sh
# Description	: Nightly Processing Scripts
# Author	: Linda S. Jefferis
# Date		: 10/31/96
# Modifications : 11/25/97 (LSJ) Added -t option to run of audit01.sh
#		: 03/13/01 (LSJ) Added subject line to mail
#		: 05/02/05 (LSJ) Added 'wc -l' email to warehouse
#		: 10/26/2005 (LSJ) Changes for Linux
#		: 10/27/2009 (LSJ) Added logic for copying ??.* files to COLO
#		: 01/09/2010 (LSJ) Changes for new production site
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_ZIP=operator@pdmi.com

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nightly.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

echo Nightly Processing Scripts
date

${SHELL_DIR}/audit_mv_sat.sh 2>&1 | ${MAIL_PROG} -s "audit_mv.sh" ${MAIL_ZIP}
${SHELL_DIR}/audit01conv.sh -t all -r 082011110820 2>&1 | ${MAIL_PROG} -s "audit01_new.sh" ${MAIL_ZIP}
${SHELL_DIR}/audit_zip_sat.sh 2>&1 | ${MAIL_PROG} -s "audit_zip.sh" ${MAIL_ZIP}

date

exit 0
