#!/bin/sh
#
# Program Name	: enrolrb01.sh
# Description   : Extract ENROL00MAS for load to warehouse         
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no Warehouse extract file writes)
#		  
# Author	: John Shrigley     
# Date		: 3/30/2016
# Modifications : 9/30/2016 - Modifications for production version. (LSJ) 
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

usage: enrolrb01.sh -t

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

	
# Submit enrolrb01 program
submit_enrolrb01()
{
      runcobol ${OBJ_DIR}/enrolrb01 -s ${TEST_MODE}
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


echo "EXTRACT ENROL00MAS TO LOAD TO WAREHOUSE"

date
echo "EXPORT PATHS:"
echo "   ENROL00MAS=$ENROL00MAS"
echo "   ENROLRB001=$ENROLRB001"

submit_enrolrb01

date

exit $RETVAL
