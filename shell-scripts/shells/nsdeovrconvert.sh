#!/bin/sh
#
# to run: nsdeovrconvert.sh
#
# Program Name  : nsdeovrconvert.sh
# Author        : gvernon 
# Date          : 03/27/2023
#

# Variables Used:
OBJ_DIR="/usr/lnk/obj"


# Submit NSDEOVRMAS convert  program
submit_nsdeovrconvert()
{

      runcobol ${OBJ_DIR}/NSDEOVRCONVERT

}


#
# Main routine

# Assign OLD NSDEOVR file
  NSDEOVRMASO=/usr/lnk/drug/NSDEOVRMAS
  export NSDEOVRMASO

# Assign NEW NSDEOVR file
  NSDEOVRMASN=/usr/lnk/drug/NSDEOVRMAS-NEW
  export NSDEOVRMASN

date
echo "EXPORT PATHS:"
echo "   INPUT=$NSDEOVRMASO "
echo "   OUTPUT=$NSDEOVRMASN "

  submit_nsdeovrconvert

date

exit 0
