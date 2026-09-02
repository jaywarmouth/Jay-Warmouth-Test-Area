#!/bin/sh
#
# Program Name  : fvss01.sh
# Description   : Warehouse FVSSRB0001 Extract
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

usage: fvss01.sh 

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


# Submit fvss01 program
submit_fvss01()
{
        runcobol ${OBJ_DIR}/fvss01  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "FVSS000MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   FVSS000MAS=${FVSS000MAS}"
echo "   FVSSRB0001=${FVSSRB0001}"
submit_fvss01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
