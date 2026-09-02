#!/bin/ksh
#
# Program Name	: pay-claim44.sh
# Description	: Special runs of claim44 for pay-cycle
#		: Command Line Arguments:
#		  -p <p/e prefix>  e.g. B16
# Author	: Linda S. Jefferis
# Date		: 01/20/2003
# Modifications : 02/17/2003 - Added "-p" command line argument logic  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
DET_RPT="CL44"
INV_RPT="CL44.INV"
PREFIX="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pay-claim44.sh -p <p/e/prefix>

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
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	PREFIX=$1
	;;
  esac
  shift
done

## SOMC ##
${SHELL_DIR}/claim44.sh -p
mv ${MISC_DIR}/${PREFIX}${DET_RPT} ${MISC_DIR}/${PREFIX}${DET_RPT}.SOMC
mv ${MISC_DIR}/${PREFIX}${INV_RPT} ${MISC_DIR}/${PREFIX}${INV_RPT}.SOMC

## Fisher Titus ##
${SHELL_DIR}/claim44.sh -p
mv ${MISC_DIR}/${PREFIX}${DET_RPT} ${MISC_DIR}/${PREFIX}${DET_RPT}.FT
mv ${MISC_DIR}/${PREFIX}${INV_RPT} ${MISC_DIR}/${PREFIX}${INV_RPT}.FT


exit 0
