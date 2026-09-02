#!/bin/sh
#
# Program Name  : compstept00mas.sh
# Author        : dick lombardo
# Date          : 09/03/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
STEPT00MAS=/usr/lnk/drug/STEPT00MAS
OLDSTEPT00MAS=/usr/pdm/OLDSTEPT00MAS
STEPT00MASDIF=/usr/pdm/STEPT00MAS.DIF
export STEPT00MAS OLDSTEPT00MAS STEPT00MASDIF


runcobol ${OBJ_DIR}/compstept00mas

exit 0