#!/bin/sh
#
# Program Name  : compclcmp00mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
CLCMP00MAS=/usr/lnk/claims/CLCMP00MAS
OLDCLCMP00MAS=/usr/pdm/OLDCLCMP00MAS
CLCMP00MASDIF=/usr/pdm/CLCMP00MAS.DIF
export CLCMP00MAS OLDCLCMP00MAS CLCMP00MASDIF


runcobol ${OBJ_DIR}/compclcmp00mas 

exit 0