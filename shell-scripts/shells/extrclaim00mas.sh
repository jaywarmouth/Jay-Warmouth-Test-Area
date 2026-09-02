#!/bin/sh
#
# Program Name  : compclaim00mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
# modifications	: 7/18/2018 - TT3200-212

OBJ_DIR="/usr/lnk/obj"

#
# Main routine
#
CLWRK00MASOLD=/usr/lnk/tmp/CLWRK00MAS.chk.20260107

CLAIM00MAS=/data/relativityfiles/CLAIM00MAS

CLWRK00MASNEW=/usr/lnk/tmp/CLWRK00MAS.chk.20250107.upd
export CLWRK00MASOLD 
export CLAIM00MAS
export CLWRK00MASNEW

date
echo "CLWRK00MASOLD=" $CLWRK00MASOLD
echo "CLAIM00MAS   =" $CLAIM00MAS
echo "CLWRK00MASNEW=" $CLWRK00MASNEW

runcobol ${OBJ_DIR}/EXTRCLAIM00MAS
date

exit 0
