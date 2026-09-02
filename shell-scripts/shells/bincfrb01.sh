#!/bin/sh
#
# Program Name	: bincfrb01.js
# Description   : Create bin config warehouse export         
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no Warehouse extract file writes)
#		  
# Author	: John Shrigley     
# Date		: 3/25/2016
# Modifications : 10/19/2018 - TT18977-29 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: bincfrb01.js -t

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

	
# Submit bincfrb01 program
submit_bincfrb01()
{
      runcobol ${OBJ_DIR}/bincfrb01 -s ${TEST_MODE} 
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


echo "BIN CONFIG WAREHOUSE EXPORT"

date
echo "EXPORT PATHS:"
echo "   BINCF00MAS=$BINCF00MAS"
echo "   BINCFRB001=$BINCFRB001"

submit_bincfrb01

date

exit $RETVAL
