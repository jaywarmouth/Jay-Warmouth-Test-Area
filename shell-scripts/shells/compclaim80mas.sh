#!/bin/sh
#
# Program Name  : compclaim80mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
CLAIM80MAS=/usr/lnk/claims/CLAIM80MAS
OLDCLAIM80MAS=/usr/pdm/OLDCLAIM80MAS
CLAIM80MASDIF=/usr/pdm/CLAIM80MAS.DIF
export CLAIM80MAS OLDCLAIM80MAS CLAIM80MASDIF


runcobol ${OBJ_DIR}/compclaim80mas

exit 0