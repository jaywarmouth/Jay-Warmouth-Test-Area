#!/bin/sh
#
# Program Name  : compcldem00mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
#

OBJ_DIR="/usr/lnk/obj"

#
# Main routine
#
CLDEM00MASN=/usr/lnk/clmsg/CLDEM00MAS
CLDEM00MASO=/usr/lnk/clmsg/CLDEM00MAS.20260722
CLDEM00MASDIF=/usr/lnk/tmp/CLDEM00MAS.DIF
export CLDEM00MASN CLDEM00MASO CLDEM00MASDIF

echo "CLDEM00MASN=${CLDEM00MASN}"
echo "CLDEM00MASO=${CLDEM00MASO}"


runcobol ${OBJ_DIR}/COMPCLDEM00MAS

exit 0
