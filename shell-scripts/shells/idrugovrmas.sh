#!/bin/sh
#
# Program Name	: idrug000mas.sh
# Description   : Initialize new fields in small MAS files
#                
#          Command Line Arguments: None
#		-p Program Name
#		-t Test Mode  
#		-i Initialize Mode
#                 
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

usage: idrug000mas.sh [program name] [-t] 
        -t      Test Initalize Fields

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

while [ $# -gt 1 ]
do
  case "$2"
  in
    -t) TEST_MODE=1
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env

DRUG000MAS=${DRUGOVRMAS}
export DRUG000MAS

echo "Initialize DRUGOVRMAS new fields"
date
echo "DRUG000MAS=${DRUG000MAS}"

runcobol ${OBJ_DIR}/IDRUG000MAS -a ${TEST_MODE} 
date

exit 0
