#!/bin/ksh
#
# Program Name  : altpr0001.sh
# Description   : Warehouse ALTPR00MAS File Extract
# Author        : DEBBE ADGATE
# Date          : 08/02/16
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj   
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: altpr0001.sh 

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


# Submit altpr0001 program
submit_altpr0001()
{
        runcobol ${OBJ_DIR}/altpr0001  
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables

ALTPR00PRM=/usr/lnk/log/altpr0001-parameter.txt
  export ALTPR00PRM

echo "Extract of ALTPR00MAS file for Warehouse"
echo "   ALTPR00RB1=${ALTPR00RB1}"
echo "   ALTPR00MAS=${ALTPR00MAS}"
echo "   ALTPR00PRM=${ALTPR00PRM}"
submit_altpr0001
echo  "   RETVAL=$RETVAL "
date

exit $RETVAL
