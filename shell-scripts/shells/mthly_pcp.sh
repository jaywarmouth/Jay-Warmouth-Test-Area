#!/bin/ksh
#
# Program Name	: mthly_pcp.sh
# Description	: Monthly PCP Procedures
#		: Line Arguments:
# Author	: Linda S. Jefferis
# Date		: 07/01/2005
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mthly_pcp.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#
# Check command line validity, call usage if incorrect


${SHELL_DIR}/pcp09c.sh -f /fs11/CAWRK00SUM.0605 -p /fs11/PCPWRK0SUM.0605 > /usr/lnk/rpt/pcp09c 2>&1
${SHELL_DIR}/pcp80c.sh -p /fs11/PCPWRK0SUM.0605 > /usr/lnk/rpt/pcp80c 2>&1
cp /usr/upd/phys/PCPCT00MAS /usr/upd/phys/PCPCT00MAS.0505
if test $? -eq 0
then
   ${SHELL_DIR}/pcpct01.sh -e -m 200503 > ${RPT_DIR}/pcpct01e 2>&1
   ${SHELL_DIR}/pcpct01.sh -c -m 200506 > ${RPT_DIR}/pcpct01c 2>&1
fi

exit 0
