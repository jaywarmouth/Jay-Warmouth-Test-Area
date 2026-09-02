#!/bin/sh
#
#
# Program Name	: onetmconvert.cbl
# Description   : Converts and Expands Key field in ONETM00MAS file 
#                 
# Author	: Jim Polk
# Date		: 12/01/2025
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: onetmconvert.sh

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


# Submit onetmconvert program
submit_onetmconvert()
{
     runcobol ${OBJ_DIR}/onetmconvert 
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

ONETM00MASO=${ONETM00MAS}
export ONETM00MASO

ONETM00MASN=${ONETM00MAS}-NEW
export ONETM00MASN

echo "CONVERT ONETM00MAS NEW FILE"

date

echo "ONETM00MASO=${ONETM00MASO}"
echo "ONETM00MASN=${ONETM00MASN}"

submit_onetmconvert

date

exit ${RETVAL}
