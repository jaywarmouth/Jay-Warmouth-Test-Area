#!/bin/sh
#
# Script Name	: overiconvert.sh
# Program Name	: overiconvert.cbl
# Description   : Convert and Expand Key field in OVERI00MAS file 
#                 
# Author	: Patrick Murphy
# Date		: 03/12/2026
# Modifications : 
# PDMI 2026 - OVERI00MAS - Halo 88686 - Adjust sizes of multiple fields in OVERI00MAS - conversion program

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

usage: overiconvert.sh

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


# Submit overiconvert program
submit_overiconvert()
{
     runcobol ${OBJ_DIR}/overiconvert 
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

OVERI00MASN=${OVERI00MAS}-NEW
export OVERI00MASN

OVERI00MASO=${OVERI00MAS}
export OVERI00MASO


echo "CONVERT OVERI00MAS NEW FILE"

date

echo "OVERI00MASN=${OVERI00MASN}"
echo "OVERI00MASO=${OVERI00MASO}"
submit_overiconvert

date

exit ${RETVAL}
