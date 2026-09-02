#!/bin/sh
#
# Program Name	: REBADCONVERT.CBL
# Description   : CREATE AND EXPAND NEW RBADM00MAS FILE
#                 Command Line Arguments: None
#                 -t TEST MODE  
#                 
# Author	: Peggy Voytilla  
# Date		: 02/25/2020
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: REBADCONVERT [-t]

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	set $VAR
	NVAR=$1
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit REBADCONVERT program
submit_rebadconvert()
{
     runcobol ${OBJ_DIR}/REBADCONVERT -s ${TEST_MODE}          
	RETVAL=$?
}


# Main routine#

# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env


# Assign alternate environment variables

# output - new master file built using new format  
  REBAD00MASN=${REBAD00MAS}-NEW
  export REBAD00MASN

# input - specifies existing master file to be converted
  REBAD00MASO=${REBAD00MAS}
  export REBAD00MASO


echo "CONVERT REBAD00MAS TO NEW FILE FORMAT"
echo "REBAD00MASN=${REBAD00MASN}"
echo "REBAD00MASO=${REBAD00MASO}"

date
submit_rebadconvert

date
echo "EXIT-CODE=$RETVAL"

exit $RETVAL
