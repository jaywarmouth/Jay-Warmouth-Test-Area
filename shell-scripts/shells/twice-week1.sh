#!/bin/ksh
#
# Program Name	: twice-week1.sh
# Description	: Week-Cycle Update and Report for twice-cycle week
# Author	: Linda S. Jefferis
# Date		: 12/09/2004
# Modifications : 03/06/2007 - Added claim109 procedure for sys0102  (LSJ)
#		: 04/02/2008 - Added claim109ihs for sys0107  (LSJ)
#		: 04/02/2008 - added the clms_aebs.sh procedure  (LSJ)
#		: 06/03/2009 - Added new ault_gt_file.sh process  (LSJ)
#		: 12 31/2009 - Removed IHS processes  (LSJ)
#		: 01/07/2010 - Added twice-wee4.sh process  (LSJ)
#		: 06/15/2010 - Removed twice-week4.sh process
#		: 11/04/2010 - Changes for new tweek cycle
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice-week1.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim109.sh -c twice -w > ${RPT_DIR}/tweek-twice-claim109 2>&1
${SHELL_DIR}/clms_aebs.sh -p ${DATE} > ${RPT_DIR}/tweek-clms_aebs 2>&1

exit 0
