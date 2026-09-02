#!/bin/sh
#
# Program Name  : compclaim00mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
# modifications	: 7/18/2018 - TT3200-212

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
CLAIM00MASN=/usr/lnk/clm_01/CLAIM00MAS
CLAIM00MASO=/usr/pdm/OLDCLAIM00MAS
CLAIM00MASDIF=/usr/pdm/CLAIM00MAS.DIF
export CLAIM00MASN CLAIM00MASO CLAIM00MASDIF


runcobol ${OBJ_DIR}/COMPCLAIM00MAS

exit 0
