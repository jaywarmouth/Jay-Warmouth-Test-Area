#!/bin/sh
#
# Script Name	: clcmpconvert.sh
# Program Name	: clcmpconvert.cbl
# Description   : Convert and Expand Key field in CLCMP00MAS file 
#                 
# Author	: Ferdinand Lim
# Date		: 12/31/2025
# Modifications : 
# TD-13069] conversion program

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
#OBJ_DIR="/home/flim/cobol/cob"
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clcmpconvert.sh

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


# Submit clcmpconvert program
submit_clcmpconvert()
{
     runcobol ${OBJ_DIR}/clcmpconvert 
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

CLCMP00MASN=${CLCMP00MAS}-NEW
export CLCMP00MASN

CLCMP00MASO=${CLCMP00MAS}
export CLCMP00MASO


echo "CONVERT CLCMP00MAS NEW FILE"

date

echo "CLCMP00MASN=${CLCMP00MASN}"
echo "CLCMP00MASO=${CLCMP00MASO}"
submit_clcmpconvert

date

exit ${RETVAL}
