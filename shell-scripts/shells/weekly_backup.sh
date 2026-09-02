#!/bin/ksh
#
# Program Name	: weekly_backup.sh
# Description	: Runs daily tape backup procedures
# Author	: Linda Jefferis
# Date		: 08/29/2005
# Modifications :
#
# Variables Used:
SHELL_DIR="/usr/lnk/backup/shl"
RPT_DIR="/usr/lnk/backup"
DATE=`date +%y%m%d`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: weekly_backup.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

umask 002

${SHELL_DIR}/bkweekly-01 > ${RPT_DIR}/wkly_full-${DATE} 2>&1


exit 0
