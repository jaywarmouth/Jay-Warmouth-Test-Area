#!/bin/sh
#
# Program Name  : comprever00mas.sh
# Author        : dick lombardo
# Date          : 09/03/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
REVER00MAS=/usr/lnk/claims/REVER00MAS
OLDREVER00MAS=/usr/pdm/OLDREVER00MAS
REVER00MASDIF=/usr/pdm/REVER00MAS.DIF
export REVER00MAS OLDREVER00MAS REVER00MASDIF


runcobol ${OBJ_DIR}/comprever00mas

exit 0