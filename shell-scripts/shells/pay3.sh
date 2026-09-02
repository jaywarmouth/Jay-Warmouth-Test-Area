#!/bin/ksh
#
# Program Name	: pay3.sh
# Description	: Pay-Cycle Reporting Section
# Author	: Linda S. Jefferis
# Date		: 04/25/96
# Modifications : 06/22/2000 - Now used to run claim07 and claim08  (LSJ)
#		: 10/26/2000 - Added limit12 to procedures  (LSJ)
#		: 05/29/2003 - Added "pay-" to names of rpt files  (LSJ)
#		: 02/04/2004 - Removed the "lp" for claim08 and limit12  (LSJ)
#		: 06/22/2004 - Readded "lp" for claim08  (LSJ)
#		: 06/15/2005 - Added claim120 procedure  (LSJ)
#		: 06/17/2005 - Moved claim20 off to procedure by itself  (LSJ)
#		: 05/30/2006 - Removed run of claim08  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pay3.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim07.sh -c pay > ${RPT_DIR}/pay-claim07 2>&1
lp ${RPT_DIR}/pay-claim07

exit 0
