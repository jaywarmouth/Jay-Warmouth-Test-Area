#!/bin/ksh
#
# Program Name  : tpmrb01.sh
# Description   : Warehouse TPM00MAS File Extract
#		  Command Line Arguments:
# Author        : Linda Jefferis
# Date          : 06/26/2015
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tpmrb01.sh 

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


# Submit tpmrb01 program
submit_tpmrb01()
{
        runcobol ${OBJ_DIR}/tpmrb01
	RETVAL="$?"
}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "TPM00MAS Extract for Warehouse"
date
echo "   TPM00MAS=${TPM00MAS}"
echo "   TPMRB001=${TPMRB001}"
submit_tpmrb01
date

exit ${RETVAL}
