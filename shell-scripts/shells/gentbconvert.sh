#!/bin/sh
#
# Program Name	: gentbconvert.sh
# Description   : Initialize gentb00mas increate gt-table-number to pic 9(8).
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Joe Novicky  e 
# Date		: 02/01/2020
# Modifications :                                               
#

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

usage: gentbconvert.sh [-t]

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


# Submit gentbconvert program
submit_gentbconvert()
{
      runcobol ${OBJ_DIR}/gentbconvert -a ${TEST_MODE}  
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

# Assign alternate environment variables
 
GENTB00MASN=${GENTB00MAS}-NEW
export  GENTB00MASN

echo "Convert GENTB00MAS"
date
echo "GENTB00MAS=${GENTB00MAS}"
echo "GENTB00MASN=${GENTB00MASN}"
submit_gentbconvert
echo  "   RET_CODE=$? "

date

exit 0
