#!/bin/sh
#
# Program Name  : comppdecl00mas.sh
# Author        : dick lombardo
# Date          : 09/03/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
PDECL00MAS=/usr/lnk/claims/PDECL00MAS
OLDPDECL00MAS=/usr/pdm/OLDPDECL00MAS
PDECL00MASDIF=/usr/pdm/PDECL00MAS.DIF
export PDECL00MAS OLDPDECL00MAS PDECL00MASDIF


runcobol ${OBJ_DIR}/comppdecl00mas

exit 0