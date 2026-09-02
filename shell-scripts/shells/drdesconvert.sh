#!/bin/sh
#
#
# Program Name  : DRDESCONVERT.CBL
# Author        : jnovicky 
# Date          : 01/18/2020
#

# Variables Used:
OBJ_DIR="/usr/lnk/obj"
RETVAL=0


# Submit DRDESCONVERT program
submit_drdesconvert()
{

      runcobol ${OBJ_DIR}/DRDESCONVERT  
	RETVAL=$?

}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	BATCHRANGE=$1
	;;
  esac
  shift
done


 DRDES00MAS=/usr/lnk/desc/DRDES00MAS  
 export DRDES00MAS

  DRDES00MASN=/usr/lnk/desc/DRDES00MAS-NEW
 export DRDES00MASN


echo "Convert DRDES00MAS File"
date
echo "   DRDES00MAS=${DRDES00MAS}"
echo "   DRDES00MASN=${DRDES00MASN}"


submit_drdesconvert
date

echo "RETURN_CODE=${RETVAL}"
exit ${RETVAL}
