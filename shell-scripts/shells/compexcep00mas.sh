#!/bin/sh
#
# Program Name  : compexcep00mas.sh
# Author        : dick lombardo
# Date          : 09/03/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
EXCEP00MAS=/usr/lnk/crd_01/EXCEP00MAS
OLDEXCEP00MAS=/usr/pdm/OLDEXCEP00MAS
EXCEP00MASDIF=/usr/pdm/EXCEP00MAS.DIF
export EXCEP00MAS OLDEXCEP00MAS EXCEP00MASDIF


runcobol ${OBJ_DIR}/compexcep00mas

exit 0