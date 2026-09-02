#!/bin/ksh
#
# Program Name	: bas_load.sh
# Description   : BAS Eligibility Tape Load 
# Author	: Linda S. Jefferis
# Date		: 09/11/97
# Modifications : 
#
# Variables Used:
TAPE_DRIVE=/dev/rmt/c0t5d0s0
LOAD_PATH=/usr/pdm/elig_in

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: bas_load.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#
# Check command line validity, call usage if incorrect

rm ${LOAD_PATH}/bas.tap
echo BAS Eligibility Tape Load
date
dd if=${TAPE_DRIVE}yn ibs=1200 of=${LOAD_PATH}/bas.tap
date

exit 0
