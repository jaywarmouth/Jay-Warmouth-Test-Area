#!/bin/sh
#
# Program Name  : compclcob00mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
CLCOB00MAS=/usr/lnk/claims/CLCOB00MAS
OLDCLCOB00MAS=/usr/pdm/OLDCLCOB00MAS
CLCOB00MASDIF=/usr/pdm/CLCOB00MAS.DIF
export CLCOB00MAS OLDCLCOB00MAS CLCOB00MASDIF


runcobol ${OBJ_DIR}/compclcob00mas

exit 0