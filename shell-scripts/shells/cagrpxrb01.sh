#!/bin/sh
#
# Program Name	: cagrpxrb01.sh
# Description   : Create CAGRPXWMAS warehouse export         
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no Warehouse extract file writes)
#		  
# Author	: Lucy A. Caraballo 
# Date		: 3/10/2025
# Modifications : 03/10/2025 - TD:8852    
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

usage: cagrpxrb01.sh -t

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

	
# Submit cagrpxrb01 program
submit_cagrpxrb01()
{
      runcobol ${OBJ_DIR}/cagrpxrb01 -s ${TEST_MODE} 
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


echo "CAGRPXWMAS WAREHOUSE EXPORT"

date
echo "EXPORT PATHS:"
echo "   CAGRPXWMAS=$CAGRPXWMAS" 
echo "   CAGRPXRB001=$CAGRPXRB001"

submit_cagrpxrb01

date

exit $RETVAL
