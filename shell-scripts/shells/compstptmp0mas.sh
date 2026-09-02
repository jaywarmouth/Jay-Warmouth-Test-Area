#!/bin/sh
#
# Program Name  : compstptmp0mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
STPTMP0MAS=/usr/lnk/audit/STPTMP0MAS.null
OLDSTPTMP0MAS=/usr/pdm/OLDSTPTMP0MAS.null
STPTMP0MASDIF=/usr/pdm/STPTMP0MAS.DIF
export STPTMP0MAS OLDSTPTMP0MAS STPTMP0MASDIF


runcobol ${OBJ_DIR}/compstptmp0mas

exit 0