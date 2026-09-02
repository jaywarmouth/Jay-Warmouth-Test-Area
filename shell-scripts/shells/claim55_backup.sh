#!/bin/ksh
#
# Program Name	: claim55_backup.sh
# Description	: Backup of CLAIM55MAS
# Author	: Linda S. Jefferis
# Date		: 09/19/2001
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
CLM_DIR="/usr/upd/claims"
TAPE_DEV="/dev/rmt/c0t5d0s0"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim55_backup.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

/usr/ucb/mt -f ${TAPE_DEV} rewind
retv="$?"
if [ "$retv" -ne "0" ]
then
        echo " "
        echo "WARNING: No tape found in drive ${TAPE_DEV}!"
        echo " "
        exit 1
else
	date
	cd ${CLM_DIR}
	echo CLAIM55MAS | cpio -ocvB > ${TAPE_DEV}
	date
fi
/usr/ucb/mt -f ${TAPE_DEV} rewind
/usr/ucb/mt -f ${TAPE_DEV} offline

exit 0
