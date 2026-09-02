#!/bin/sh
#
# to run: etrafconvert.sh
#
# Program Name  : etraf_convert.sh
# Author        : gvernon 
# Date          : 01/17/2023
#

# Variables Used:

OBJ_DIR="/usr/lnk/obj"


# Submit ETRAF00MAS convert  program
submit_etrafconvert()
{

      runcobol ${OBJ_DIR}/ETRAFCONVERT

}


#
# Main routine

# Assign OLD ETRAF file
  ETRAF00MASO=/usr/lnk/claims/ETRAF00MAS
  export ETRAF00MASO

# Assign NEW ETRAF file
  ETRAF00MASN=/usr/lnk/claims/ETRAF00MAS-NEW
  export ETRAF00MASN

# Assign DATAERROR file
  DATAERROR=/tmp/ETRAF00MAS-ERROR
  export DATAERROR

date
echo "EXPORT PATHS:"
echo "   INPUT=$ETRAF00MASO "
echo "   OUTPUT=$ETRAF00MASN "
echo "   DATAERROR=$DATAERROR "

  submit_etrafconvert

date

exit 0
