#!/bin/sh
#
# Program Name	: SPECTBCONVERT 
# Description   : Convert SPECTB0MAS for changes in file
#                 Command Line Arguments: None
#                 
# Author	: Mike Paulus
# Date		: 11/04/2019
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: SPECTBCONVERT
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


 # Submit SPECTBCONVERT program
submit_spectbconvert()
{
     runcobol ${OBJ_DIR}/spectbconvert 
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

SPECTB0MASO=${SPECTB0MAS}
export SPECTB0MASO
  
SPECTB0MASN=${SPECTB0MAS}-NEW
  export SPECTB0MASN


DATAERROR=/tmp/SPECTBWRK-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/tmp/loadtimes-spectbconvert
  export LOADTIMES

echo "CONVERT SPECTB0MAS NEW FILE"

date
echo "SPECTB0MASO=${SPECTB0MASO}"
echo "SPECTB0MASN=${SPECTB0MASN}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_spectbconvert
echo  "   RET_CODE=$RETVAL " 

date

exit ${RETVAL}
