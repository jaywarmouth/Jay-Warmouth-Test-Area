#!/bin/sh
#
# Script Name	:  reverconvert.sh
# Program Name	:  reverconvert.cbl
# Description   : Convert  REVER00MAS file 
#                 
# Author	: Ferdinand Lim
# Date		: 06/30/2026
# Modifications : 
# PDMI 2026 -  REVER00MAS - PROJ-65383 [COBOL F6] - Adjust fields changing for F6 - conversion program
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

usage:  reverconvert.sh

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


# Submit  reverconvert program
submit_reverconvert()
{
     runcobol ${OBJ_DIR}/REVERCONVERT
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

REVER00MASN=${REVER00MAS}-NEW
export  REVER00MASN

REVER00MAS=${REVER00MAS}
export  REVER00MAS


echo "CONVERT  REVER00MAS NEW FILE"

date

echo " REVER00MASN=${REVER00MASN}"
echo " REVER00MAS=${REVER00MAS}"
submit_reverconvert

date

exit ${RETVAL}
