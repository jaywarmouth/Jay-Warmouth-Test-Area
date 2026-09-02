#!/bin/sh
#
# Program Name  : rcd01.sh
# Description   : Warehouse RCDRB001 Extract
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

usage: rcd01.sh 

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


# Submit rcd01 program
submit_rcd01()
{
        runcobol ${OBJ_DIR}/rcd01  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "RCD0000MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   RCD0000MAS=${RCD0000MAS}"
echo "   RCDRB001=${RCDRB001}"
submit_rcd01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
