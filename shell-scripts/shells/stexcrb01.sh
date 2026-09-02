#!/bin/sh
#
# Program Name  : stexcrb01.sh
# Description   : Warehouse STEXCRB001 Extract
#		  Command Line Arguments: None
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: stexcrb01.sh 

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


# Submit stexcrb01 program
submit_stexcrb01()
{
        runcobol ${OBJ_DIR}/stexcrb01  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "STEXC00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   STEXC00MAS=${STEXC00MAS}"
echo "   STEXCRB001=${STEXCRB001}"
submit_stexcrb01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
