#!/bin/ksh
#
# Program Name	: initoveri.sh
# Description   : Initialize OVERI00MAS new fields
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Janice L. Lanzo
# Date		: 08/05/2015
# Modifications : Production version updates (LSJ-TT:13654-7)


# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: initoveri.sh [-t]

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



#
# Main routine
#
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

echo "Initialize OVERI00MAS new fields"
date
echo "OVERI00MAS=${OVERI00MAS}"

runcobol ${OBJ_DIR}/IOVERI00MAS -s ${TEST_MODE} 
date

exit 0
