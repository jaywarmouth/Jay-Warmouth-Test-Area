#!/bin/sh
#
# Program Name  : compcardi00mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
CARDI00MAS=/usr/lnk/crd_01/CARDI00MAS
OLDCARDI00MAS=/usr/pdm/OLDCARDI00MAS
CARDI00MASDIF=/usr/pdm/CARDI00MAS.DIF
export CARDI00MAS OLDCARDI00MAS CARDI00MASDIF


runcobol ${OBJ_DIR}/compcardi00mas

exit 0