#!/bin/sh
#
# Program Name  : componetm00mas.sh
# Author        : dick lombardo
# Date          : 09/03/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
ONETM00MAS=/usr/lnk/crd_01/ONETM00MAS
OLDONETM00MAS=/usr/pdm/OLDONETM00MAS
ONETM00MASDIF=/usr/pdm/ONETM00MAS.DIF
export ONETM00MAS OLDONETM00MAS ONETM00MASDIF

runcobol ${OBJ_DIR}/componetm00mas

exit 0