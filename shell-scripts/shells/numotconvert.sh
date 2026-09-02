#!/bin/sh
#
# Script Name	: numotconvert.sh
# Program Name	: numotconvert.cbl
# Description   : Convert and Expand Key field in NUMOT00MAS file 
#                 
# Author	: Mary Jennings
# Date		: 12/03/2025
# Modifications : 
# TD-12702 - PDMI 2025 - NUMOT00MAS - Halo 74990 - Add new First Name field - conversion program

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

usage: numotconvert.sh

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


# Submit numotconvert program
submit_numotconvert()
{
     runcobol ${OBJ_DIR}/numotconvert 
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

NUMOT00MASN=${NUMOT00MAS}-NEW
export NUMOT00MASN

NUMOT00MASO=${NUMOT00MAS}
export NUMOT00MASO


echo "CONVERT NUMOT00MAS NEW FILE"

date

echo "NUMOT00MASN=${NUMOT00MASN}"
echo "NUMOT00MASO=${NUMOT00MASO}"
submit_numotconvert

date

exit ${RETVAL}
