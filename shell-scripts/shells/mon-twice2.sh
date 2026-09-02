#!/bin/ksh
#
# Program Name	: mon-twice2.sh
# Description	: Month-Cycle - Reports
# Author	: Linda S. Jefferis
# Date		: 06/21/96
# Modifications : 04/01/99 - Removed claim72 run  (LSJ)
#		: 06/28/2001 - Removed claim109 and claim94 runs  (LSJ)
#		: 11/24/2004 - eliminated the sys run of claim13 and spo run of claim38  (LSJ)
#		: 01/03/2006 - Added claim34.sh (LSJ)
#		: 01/22/2007 - Removed claim11, claim13, claim36, claim38, claim31, and claim32 since Aultman no longer needs any of these reports  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
TSTSHL_DIR="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mon-twice2.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim34.sh -c twice  > ${RPT_DIR}/mon-t-claim34 2>&1

exit 0
