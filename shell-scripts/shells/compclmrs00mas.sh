#!/bin/sh
#
# Program Name  : compclmrs00mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
CLMRS00MAS=/usr/lnk/restack/CLMRS00MAS
OLDCLMRS00MAS=/usr/pdm/OLDCLMRS00MAS
CLMRS00MASDIF=/usr/pdm/CLMRS00MAS.DIF
export CLMRS00MAS OLDCLMRS00MAS CLMRS00MASDIF


runcobol ${OBJ_DIR}/compclmrs00mas

exit 0