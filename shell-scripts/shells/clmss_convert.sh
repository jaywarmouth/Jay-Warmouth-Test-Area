#!/bin/sh
#
#
# Program Name  : clmss_convert.sh
# Author        : gvernon 
# Date          : 07/18/2019
#

# Variables Used:
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
BATCHRANGE="00000000aZ99Z999"
USEPARMS=" "
USEPARMS_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmss_convert.sh -b <batchrange> -p
        all input parameters are optional:
                -b <batchrange> - default is entire file (00000000ZZ99Z999)
		-p 		- flag to use CLMSS00PRM input file for claims

ENDOFUSAGE
  exit 99
}

# Submit CLMSSCONVERT program
submit_clmssconvert()
{

      runcobol ${OBJ_DIR}/CLMSSCONVERT -C /usr/rmcobol/terminfo-d0.cfg -a ${BATCHRANGE}
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
    -p) USEPARMS="Y"
	USEPARMS_FLG=1
        ;;
  esac
  shift
done


CLMSS00PRM=/tmp/CLMSS00PRM.txt
echo CLMSS00PRM

  CLMSS00MASOLD=/usr/lnk/clmss/CLMSS00MAS  
  export CLMSS00MASOLD

  CLMSS00MASNEW=/usr/lnk/clmss/CLMSS00MAS-NEW
  export CLMSS00MASNEW


echo "Convert CLMSS File"
date
if [ ${USEPARMS_FLG} = 1 ]
then
  echo "   CLMSS00PRM=${CLMSS00PRM}"
else
  echo "   RANGE=${BATCHRANGE}"
fi
echo "   CLMSS00MASOLD=${CLMSS00MASOLD}"
echo "   CLMSS00MASNEW=${CLMSS00MASNEW}"


submit_clmssconvert
date

echo "RETURN_CODE=${RETVAL}"
exit ${RETVAL}
