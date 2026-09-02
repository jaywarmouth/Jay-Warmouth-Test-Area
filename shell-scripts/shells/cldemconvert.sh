#!/bin/sh
#
# Script Name	: cldemconvert.sh
# Program Name	: cldemconvert.cbl
# Description   : Convert CLDEM00MAS file 
#                 
# Author	: Patrick Murphy
# Date		: 03/17/2026
# Modifications : 
# PDMI 2026 - CLDEM00MAS - Halo 88686 - Adjust sizes of multiple fields in CLDEM00MAS - conversion program

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

usage: cldemconvert.sh

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


# Submit cldemconvert program
submit_cldemconvert()
{
     runcobol ${OBJ_DIR}/cldemconvert 
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

CLDEM00MASN=${CLDEM00MAS}-NEW
export CLDEM00MASN

CLDEM00MASO=${CLDEM00MAS}
export CLDEM00MASO


echo "CONVERT CLDEM00MAS NEW FILE"

date

echo "CLDEM00MASN=${CLDEM00MASN}"
echo "CLDEM00MASO=${CLDEM00MASO}"
submit_cldemconvert

date

exit ${RETVAL}
