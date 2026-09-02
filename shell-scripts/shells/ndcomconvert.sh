#!/bin/sh
#
# Program Name	: ndcomconvert.sh
# Description   : Initialize and expand ndcom gtw-table-number key field  
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Tony Krynicky
# Date		: 03/08/2018
# Modifications :                                               
#

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

usage: ndcomconvert.sh [-t]

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


# Submit ndcomconvert program
submit_ndcomconvert()
{
      runcobol ${OBJ_DIR}/ndcomconvert -t ${TEST_MODE}  
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
    -t) TEST_MODE=1
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env

# Assign alternate environment variables
 
NDCOM00MASO=$NDCOM00MAS
  export NDCOM00MASO
NDCOM00MASN=$NDCOM00MAS-NEW
  export NDCOM00MASN
NDCOMOERROR=$NDCOM00MAS-ERRORS    
  export NDCOMOERROR

echo "Convert NDCOM00MAS"
date
echo "NDCOM00MASO=${NDCOM00MASO}"
echo "NDCOM00MASN=${NDCOM00MASN}"
echo "NDCOMOERROR=${NDCOMOERROR}"
submit_ndcomconvert
echo  "   RET_CODE=$RETVAL "

date

exit $RETVAL
