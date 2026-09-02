#!/bin/sh
#
# Program Name	: irejcd01.sh
# Description   : Initialize REJCD00MAS new fields
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Date		: 06/04/2018
# Modifications : Updates for production version of script (LSJ)


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

usage: irejcd01.sh [-t]

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


# Submit irejcd01 program
submit_irejcd01()
{
	runcobol ${OBJ_DIR}/irejcd01 -s ${TEST_MODE}       
	RETVAL="$?"
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

  
echo "Initialize REJCD00MAS new fields"
date
echo "REJCD00MAS=${REJCD00MAS}"

submit_irejcd01 
date

exit ${RETVAL}
