#!/bin/sh
#
# Program Name  : comprestk00mas.sh
# Author        : dick lombardo
# Date          : 09/03/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
RESTK00MAS=/usr/lnk/restack/RESTK00MAS
OLDRESTK00MAS=/usr/pdm/OLDRESTK00MAS
RESTK00MASDIF=/usr/pdm/RESTK00MAS.DIF
export RESTK00MAS OLDRESTK00MAS RESTK00MASDIF


runcobol ${OBJ_DIR}/comprestk00mas

exit 0