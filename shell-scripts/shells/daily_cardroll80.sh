#!/bin/sh
#
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
PATH=/usr/rmcobol:$PATH
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_cardroll80.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

# Check command line validity, call usage if incorrect


umask 000

echo "--> Remove output files older than 30 days"
find /usr/lnk/misc -follow -name "???CARDROLL80" -mtime +30 -exec rm -f {} \;

${SHELL_DIR}/cardroll80.sh > ${RPT_DIR}/cardroll80 2>&1
RETVAL=$?
cat ${RPT_DIR}/cardroll80 | ${MAIL_PROG} -s "DAILY CARDROLL80" ${MAIL_TO}


exit $RETVAL
