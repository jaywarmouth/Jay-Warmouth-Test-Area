MDGAP00MAS          MDG-CLAIM-KEY

#!/bin/sh
#
# Program Name  : MDGAP00MAS.sh
# Author        : dick lombardo
# Date          : 09/02/2014
#

OBJ_DIR="/usr/lnk/tst"

#
# Main routine
#
MDGAP00MAS=/usr/lnk/claims/MDGAP00MAS
OLDMDGAP00MAS=/usr/pdm/OLDMDGAP00MAS
MDGAP00MASDIF=/usr/pdm/MDGAP00MAS.DIF
export MDGAP00MAS OLDMDGAP00MAS MDGAP00MASDIF


runcobol ${OBJ_DIR}/compmdgap00mas

exit 0