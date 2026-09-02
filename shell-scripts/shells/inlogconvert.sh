#!/bin/sh
#
# Program Name	: INLOGCONVERT
# Description   : Convert INLOG000MAS for changes in file
#                 Command Line Arguments: None
#                 
# Author	: Mike Paulus
# Date		: 09/26/2019
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: INLOGCONVERT
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


# Submit INLOGCONVERT program
submit_inlogconvert()
{
     runcobol ${OBJ_DIR}/INLOGCONVERT
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

INLOG00MASO=${INLOG00MAS}
export INLOG00MASO
  
INLOG00MASN=${INLOG00MAS}-NEW
  export INLOG00MASN

INLOG00MASA=${INLOG00MAS}-ARCH
  export INLOG00MASA

DATAERROR=${INLOG00MAS}-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/tmp/loadtimes-inlogconvert
  export LOADTIMES

echo "CONVERT INLOG000MAS NEW FILE"

date
echo "INLOG00MASO=${INLOG00MASO}"
echo "INLOG00MASN=${INLOG00MASN}"
echo "INLOG00MASA=${INLOG00MASA}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_inlogconvert

date
echo "  RET_CODE=$RETVAL"

exit ${RETVAL}
