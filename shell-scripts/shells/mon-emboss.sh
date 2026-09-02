#!/bin/ksh
#
# Program Name	: mon-emboss.sh
# Description	: Monthly - Embossed Cards Reporting
# Author	: Linda S. Jefferis
# Date		: 06/21/96
# Modifications : 05/02/97 - Removed proc_audit  (LSJ)
#		: 08/05/2005 - Changed script to run both pay and twice emboss procedures  (LSJ)
#		: 09/15/2014 - Add tweek processes (Ticket #11688)
#		: 02/09/2016 - TT13915-19 "week" logic
#		: 1/3/2018 - TT:1730-57; remove "tweek" logic.
#		: 1/17/2018 - TT1730-58; remove "pay" logic.
#		: 2/2/2018 - TT18170-2; add "tweek" back.
#		: 07/08/2019 - TT13915-85; remove "week" run.
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mon-emboss.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/mon-tweek-emboss.sh > ${RPT_DIR}/mon-emboss 2>&1
${SHELL_DIR}/mon-twice-emboss.sh >> ${RPT_DIR}/mon-emboss 2>&1

exit 0
