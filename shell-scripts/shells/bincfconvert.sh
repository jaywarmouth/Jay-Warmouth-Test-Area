#!/bin/sh
#
# Program Name	: bincfconvert
# Description   : Convert BINCF000MAS for changes in file
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

usage: bincfconvert
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


# Submit bincfconvert program
submit_bincfconvert()
{
     runcobol ${OBJ_DIR}/bincfconvert
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

BINCF00MASO=${BINCF00MAS}
export BINCF00MASO
  
BINCF00MASN=${BINCF00MAS}-NEW
  export BINCF00MASN


DATAERROR=/tmp/BINCFWRK-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/tmp/loadtimes-bincfconvert
  export LOADTIMES

echo "CONVERT BINCF000MAS NEW FILE"

date
echo "BINCF00MASO=${BINCF00MASO}"
echo "BINCF00MASN=${BINCF00MASN}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_bincfconvert

date
echo "  RET_CODE=$RETVAL"

exit ${RETVAL}
