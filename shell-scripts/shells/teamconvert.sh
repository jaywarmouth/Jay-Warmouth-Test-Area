#!/bin/sh
#
# Program Name	: TEAMCONVERT 
# Description   : Convert TEAM0000MAS for changes in file
#                 Command Line Arguments: None
#                 
# Author	: Debbe Kitmiller
# Date		: 10/25/2019
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

usage: TEAMCONVERT
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


# Submit TEAMCONVERT program
submit_teamconvert()
{
     runcobol ${OBJ_DIR}/TEAMCONVERT 
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

TEAM000MASO=${TEAM000MAS}
export TEAM000MASO
  
TEAM000MASN=${TEAM000MAS}-NEW
  export TEAM000MASN


DATAERROR=/tmp/TEAMWRK-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/tmp/loadtimes-teamconvert
  export LOADTIMES

echo "CONVERT TEAM000MAS NEW FILE"

date
echo "TEAM000MASO=${TEAM000MASO}"
echo "TEAM000MASN=${TEAM000MASN}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_teamconvert

date
echo "  RET_CODE=$RETVAL"

exit ${RETVAL}
