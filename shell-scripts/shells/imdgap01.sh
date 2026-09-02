#!/bin/sh
#
# Program Name	: imdgap01.sh
# Description   : Initialize MDGAP00MAS new fields
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Janice L. Lanzo
# Date		: 04/02/2015
# Modifications : 04/06/2015 - Modifications for production version


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

usage: imdgap01.sh [-t]

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


# Submit imdgap01 program
submit_imdgap01()
{
     runcobol ${OBJ_DIR}/imdgap01 -s ${TEST_MODE}       
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
  

echo "Initialize MDGAP00MAS new fields"
date
echo "MDGAP00MAS=${MDGAP00MAS}"

submit_imdgap01 
date

exit 0
