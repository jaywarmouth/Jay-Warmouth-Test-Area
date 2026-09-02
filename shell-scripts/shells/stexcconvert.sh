#!/bin/sh
#
# Program Name	: stexcconvert
# Description   : Convert STEXC000MAS for changes in file
#                 Command Line Arguments: None
#                 
# Author	: Debbe Kitmiller
# Date		: 01/13/2020
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

usage: stexcconvert
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


# Submit stexcconvert program
submit_stexcconvert()
{
     runcobol ${OBJ_DIR}/STEXCCONVERT
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

STEXC00MASO=${STEXC00MAS}
export STEXC00MASO
  
STEXC00MASN=${STEXC00MAS}-NEW
  export STEXC00MASN


DATAERROR=/tmp/STEXCWRK-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/usr/lnk/wrk/loadtimes
  export LOADTIMES

echo "CONVERT STEXC000MAS NEW FILE"

date
echo "STEXC00MASO=${STEXC00MASO}"
echo "STEXC00MASN=${STEXC00MASN}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_stexcconvert

date
echo "  RET_CODE=$RETVAL"

exit ${RETVAL}
