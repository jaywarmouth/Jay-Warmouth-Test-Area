#!/bin/sh
#
# Program Name  : planconvert.sh
# Author        : j novicky    
# Date          : 04/23/2020
#

OBJ_DIR="/usr/lnk/obj"

#
# Main routine
#  NOTE : PLAN000MAS WILL BE OPENED OUTPUT AS NEW each time run 
PLAN000MAS=/usr/lnk/grp/PLAN000MAS-NEW
OLDPLAN000MAS=/usr/lnk/grp/PLAN000MAS
export PLAN000MAS OLDPLAN000MAS

LOADTIMES=/usr/lnk/wrk/loadtimes
  export LOADTIMES

echo "PLAN000MAS Conversion"
echo "EXPORT PATHS:"
echo "  INPUT=${OLDPLAN000MAS}"
echo "  OUTPUT=${PLAN000MAS}"
echo "  LOADTIMES=${LOADTIMES}"

runcobol ${OBJ_DIR}/planconvert


exit 0
