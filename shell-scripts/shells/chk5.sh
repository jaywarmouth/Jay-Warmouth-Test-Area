#!/bin/ksh
#
# Program Name	: chk5.sh
# Description	: Check Run Report Processing - Payment Reconciliation
#                 Runs: reconx12.sh -i -v and reconx12.sh -v
#                 Command line:
#                 -f Sends alternate CLAIM00MAS to shells
# Author	: Linda S. Jefferis
# Date		: 10/30/2011
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk5.sh [-f <filename>]

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

# Check command line validity
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        ;;
  esac
  shift
done

if [ ${FILE} = "null" ]
then
   usage
else
   ${SHELL_DIR}/reconx12.sh -f ${FILE} -i -v > ${RPT_DIR}/chk-reconx12-5010-ind 2>&1
   ${SHELL_DIR}/reconx12.sh -f ${FILE} -v > ${RPT_DIR}/chk-reconx12-5010 2>&1
fi

exit 0
