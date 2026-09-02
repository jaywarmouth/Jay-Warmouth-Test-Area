#!/bin/sh
#
# Program Name  : drug003rb01.sh
# Description   : Warehouse DRUG003RB001 Extract
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

usage: drug003rb01.sh 

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


# Submit drug003rb01 program
submit_drug003rb01()
{
        runcobol ${OBJ_DIR}/drug003rb01  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "DRUG003MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   DRUG003MAS=${DRUG003MAS}"
echo "   DRUG003RB001=${DRUG003RB001}"
submit_drug003rb01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
