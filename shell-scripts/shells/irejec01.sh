#!/bin/sh
#
# Program Name	: irejec01.sh
# Description   : Initialize REJEC00MAS new fields
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Janice L. Lanzo
# Date		: 04/16/2015
# Modifications : 


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

usage: irejec01.sh [-t]

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


# Submit irejec01 program
submit_irejec01()
{
     runcobol ${OBJ_DIR}/irejec01 -s ${TEST_MODE}       
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
  

echo "Initialize REJEC00MAS new fields"
date
echo "REJEC00MAS=${REJEC00MAS}"

submit_irejec01 
date

exit 0
