#!/bin/sh
#
# Program Name	: mconfrb01.sh
# Description   : Create compu05 config warehouse export         
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no Warehouse extract file writes)
#		  
# Author	: James Polk    
# Date		: 08/01/2023
# Modifications :                         
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj

TEST_MODE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mconfrb01.sh -t

ENDOFUSAGE
  exit 1
}


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

	
# Submit mconfrb01 program
submit_mconfrb01()
{
      runcobol ${OBJ_DIR}/mconfrb01 -s ${TEST_MODE} 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
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

MCONFRB001=${MCONFMRB01}; export MCONFRB001

echo "MCONF00MAS WAREHOUSE EXPORT"

date
echo "EXPORT PATHS:"
echo "   MCONF00MAS=$MCONF00MAS"
echo "   MCONFRB001=$MCONFRB001"

submit_mconfrb01

date

exit $RETVAL
