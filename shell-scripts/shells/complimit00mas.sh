#!/bin/sh
#
# Program Name  : complimit00mas.sh
# Author        : dick lombardo
# Date          : 09/03/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
LIMIT00MAS=/usr/lnk/crd_01/LIMIT00MAS
OLDLIMIT00MAS=/usr/pdm/OLDLIMIT00MAS
LIMIT00MASDIF=/usr/pdm/LIMIT00MAS.DIF
export LIMIT00MAS OLDLIMIT00MAS LIMIT00MASDIF


runcobol ${OBJ_DIR}/complimit00mas

exit 0