#!/bin/ksh
#
# Program Name	: wkly_cms.sh
# Description	: Weekly CMS files for SummaCare
# Author	: Linda S. Jefferis
# Date		: 11/05/2004
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wkly_cms.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/drugcms01.sh > ${RPT_DIR}/drugcms01 2>&1
${SHELL_DIR}/pharm04.sh -t 0035 > ${RPT_DIR}/pharm04 2>&1
${SHELL_DIR}/tr-cms.sh > ${RPT_DIR}/tr-cms 2>&1

exit 0
