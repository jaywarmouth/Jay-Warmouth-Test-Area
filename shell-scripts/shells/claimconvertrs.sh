#!/bin/sh
#
# Script Name	: claimconvertrs.sh
# Program Name	: CLAIMCONVERTRS.CBL
# Description   : Convert CLMRS00MAS file 
#                 
# Author	: Mary Jennings
# Date		: 07/24/2026
# Modifications : 
# TD-15582 - PDMI 2026 - CLMRS00MAS - PROJ-65383 [COBOL F6] - Adjust fields changing for F6 - conversion program
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

usage:  claimconvertrs.sh

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


# Submit  CLAIMCONVERTRS.CBL program
submit_CLAIMCONVERTRS()
{
     runcobol ${OBJ_DIR}/CLAIMCONVERTRS -a F
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

 CLMRS00MASN=${CLMRS00MAS}-NEW
export  CLMRS00MASN

 CLMRS00MASO=${CLMRS00MAS}
export CLMRS00MASO


echo "CONVERT CLMRS00MAS NEW FILE"

date

echo "CLMRS00MASN=${CLMRS00MASN}"
echo "CLMRS00MASO=${CLMRS00MASO}"
submit_CLAIMCONVERTRS

date

exit ${RETVAL}
