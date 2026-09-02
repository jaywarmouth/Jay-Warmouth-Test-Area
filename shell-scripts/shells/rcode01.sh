#!/bin/sh
#
# Program Name  : rcode01.sh
# Description   : Warehouse RCODERB001 Extract
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

usage: rcode01.sh 

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


# Submit rcode01 program
submit_rcode01()
{
        runcobol ${OBJ_DIR}/rcode01  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "RCODE00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   RCODE00MAS=${RCODE00MAS}"
echo "   RCODERB001=${RCODERB001}"
submit_rcode01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
