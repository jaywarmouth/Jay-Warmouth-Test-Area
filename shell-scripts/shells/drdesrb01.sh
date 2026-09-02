#!/bin/sh
#
# Program Name  : drdesrb01.sh
# Description   : Warehouse DRDESRB001 Extract
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

usage: drdesrb01.sh 

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


# Submit drdesrb01 program
submit_drdesrb01()
{
        runcobol ${OBJ_DIR}/drdesrb01  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "DRDES00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   DRDES00MAS=${DRDES00MAS}"
echo "   DRDESRB001=${DRDESRB001}"
submit_drdesrb01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
