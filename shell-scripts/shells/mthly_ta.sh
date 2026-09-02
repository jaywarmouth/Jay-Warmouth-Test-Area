#!/bin/ksh
#
# Program Name	: mthly_ta.sh
# Description	: Monthly SummaCare TA Update and File
#		  Command Line Arguments:
#		  -b <batch range><m/e-ccyymmdd>
# Author	: Linda S. Jefferis
# Date		: 06/25/2004
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
INPUT_DATA="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mthly_ta.sh -b <batch range><m/e-ccyymmdd>
	<batch range>	Calendar month batch range
	<m/e-ccyymmdd>	

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	INPUT_DATA=$1
	;;
  esac
  shift
done

if [ ${INPUT_DATA} = "null" ]
then
   echo "-*> This procedure needs calendar month batch range and date as input to process"
   exit 1
else
   ${SHELL_DIR}/claim59.sh -t > ${RPT_DIR}/ta-claim59 2>&1
   ${SHELL_DIR}/clmta01.sh -b ${INPUT_DATA} > ${RPT_DIR}/ta-clmta01 2>&1
   ${SHELL_DIR}/tr-clmta.sh > ${RPT_DIR}/ta-tr-clmta 2>&1
fi

exit 0
