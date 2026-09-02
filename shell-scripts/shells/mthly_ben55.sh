#!/bin/ksh
#
# Program Name	: mthly_ben55.sh
# Description	: Monthly Benefit55 Procedures
#		: Line Arguments:
#		  -d <ccyymm>
# Author	: Linda S. Jefferis
# Date		: 02/17/2005
# Modifications : 09/01/2005 - Added "umask 002" command  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mthly_ben55.sh -d <ccyymm>

ENDOFUSAGE
  exit 1
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done

umask 002

${SHELL_DIR}/benefit09.sh > ${RPT_DIR}/benefit09 2>&1
${SHELL_DIR}/benefit80.sh > ${RPT_DIR}/benefit80 2>&1
${SHELL_DIR}/benefit55.sh -m ${DATE} > ${RPT_DIR}/benefit55 2>&1
cp /usr/lnk/grp/BEN5500MAS /usr/upd/grp/BEN5500MAS.bak
if test $? -eq 0
then
   ${SHELL_DIR}/ben55merge.sh -m ${DATE} > ${RPT_DIR}/ben55merge 2>&1
fi

exit 0
