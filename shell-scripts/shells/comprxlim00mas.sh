#!/bin/sh
#
# Program Name  : comprxlim00mas.sh
# Author        : dick lombardo
# Date          : 09/03/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
RXLIM00MAS=/usr/lnk/crd_01/RXLIM00MAS
OLDRXLIM00MAS=/usr/pdm/OLDRXLIM00MAS
RXLIM00MASDIF=/usr/pdm/RXLIM00MAS.DIF
export RXLIM00MAS OLDRXLIM00MAS RXLIM00MASDIF


runcobol ${OBJ_DIR}/comprxlim00mas

exit 0