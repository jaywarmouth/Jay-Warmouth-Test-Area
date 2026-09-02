#!/bin/sh
#
# Program Name	: mconfigconvert01
# Description   : Convert MCONFIGMAS for changes in file
#                 Command Line Arguments: None
#                 
# Author	: Mike Paulus
# Date		: 03/06/2020
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

usage: mconfigconvert01
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


# Submit mconfigconvert01 program
submit_mconfigconvert01()
{
     runcobol ${OBJ_DIR}/mconfigconvert01
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

MCONFIGMASO=${MCONFIGMAS}
export MCONFIGMASO
  
MCONFIGMASN=${MCONFIGMAS}-NEW
  export MCONFIGMASN


DATAERROR=/tmp/MCFGWRK-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/tmp/loadtimes-mconfigconvert01
  export LOADTIMES

echo "CONVERT MCONFIGMAS NEW FILE"

date
echo "MCONFIGMASO=${MCONFIGMASO}"
echo "MCONFIGMASN=${MCONFIGMASN}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_mconfigconvert01

date
echo "  RET_CODE=$RETVAL"

exit ${RETVAL}
