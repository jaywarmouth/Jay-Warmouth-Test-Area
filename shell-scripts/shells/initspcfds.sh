#!/bin/ksh
#
# Program Name	: initspcfds.sh
# Description   : Initialize SPCFDS0MAS new fields
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Linda Jefferis
# Date		: 10/19/2015


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

usage: initspcfds.sh [-t]

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

echo "Initialize SPCFDS0MAS new fields"
date
echo "SPCFDS0MAS=${SPCFDS0MAS}"

runcobol ${OBJ_DIR}/ISPCFDS0MAS -s ${TEST_MODE} 
date

exit 0
