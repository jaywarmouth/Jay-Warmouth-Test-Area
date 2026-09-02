#!/bin/sh
#
# Program Name	: excepconvertsh
# Description   : Convert old limit to expanded numeric field new limit file
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Debbe A. Adgate 
# Date		: 01/06/2017
# Modifications : 01/06/2017 - Initial created                
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
RETVAL=0
CONVERT_DIR=/usr/lnk/oper-wt
DATETM=`date +%Y%m%d_%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: excepconvert.sh [-t]

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


# Submit excepconvert program
submit_excepconvert()
{
      runcobol ${OBJ_DIR}/excepconvert -a ${TEST_MODE}   
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
EXCEPFIX=${CONVERT_DIR}/excepfix.txt
  export EXCEPFIX 
EXCEPOUT=${CONVERT_DIR}/EXCEPOUT-${DATETM}.txt 
  export  EXCEPOOUT

echo "EXCEP00MAS FIELD/FILE CONVERSION/CORRECTION"
date
echo "EXCEP00MAS=${EXCEP00MAS}"
echo "EXCEPOUT=${EXCEPOUT}"
echo "EXCEPFIX=${EXCEPFIX}"
submit_excepconvert 
echo  "   RET_CODE=$RETVAL "
echo "excepconvert completed"
date

exit $RETVAL
