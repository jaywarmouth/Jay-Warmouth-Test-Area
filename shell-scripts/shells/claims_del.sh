#!/bin/ksh
#
# Program Name	: claims_del.sh
# Description	: Runs claim102
#
# Author	: Linda S. Jefferis
# Date		: 03/06/98
# Modifications : 05/31/2002 - Added Hostname logic  (LSJ)
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 01/19/2006 - Removed Hostname logic  (LSJ)
#		: 03/24/2006 - Added umask so right permissions are assigned when new files are created  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
FILE="null"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claims_del.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

umask 000

	${SHELL_DIR}/claim102.sh -w -d -u -b NG01A000NJ01A000 -o "/usr/clm/d0/CLAIMS_qu3_13     " -n CLAIM00MAS_Q3_13 > ${RPT_DIR}/claim102 2>&1

exit 0
