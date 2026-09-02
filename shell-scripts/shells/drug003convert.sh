#!/bin/sh
#
# Program Name	: DRUG003CONVERT 
# Description   : Convert DRUG003MAS for changes in file
#                 Command Line Arguments: None
#                 
# Author	: Mike Paulus
# Date		: 01/07/2020
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

usage: DRUG003CONVERT
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


 # Submit DRUG003CONVERT program
submit_drug003convert()
{
     runcobol ${OBJ_DIR}/drug003convert 
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

DRUG003MASO=${DRUG003MAS}
export DRUG003MASO
  
DRUG003MASN=${DRUG003MAS}-NEW
  export DRUG003MASN


DATAERROR=/tmp/DRUG003WRK-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/tmp/loadtimes-drug003convert
  export LOADTIMES

echo "CONVERT DRUG003MAS NEW FILE"

date
echo "DRUG003MASO=${DRUG003MASO}"
echo "DRUG003MASN=${DRUG003MASN}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_drug003convert
echo  "EXIT_CODE=${RETVAL}" 

date

exit ${RETVAL}
