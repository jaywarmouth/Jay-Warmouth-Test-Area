#!/bin/sh
#
# Program Name  : compstatu00mas.sh
# Author        : dick lombardo
# Date          : 09/03/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
STATU00MAS=/usr/lnk/claims/STATU00MAS
OLDSTATU00MAS=/usr/pdm/OLDSTATU00MAS
STATU00MASDIF=/usr/pdm/STATU00MAS.DIF
export STATU00MAS OLDSTATU00MAS STATU00MASDIF


runcobol ${OBJ_DIR}/compstatu00mas

exit 0