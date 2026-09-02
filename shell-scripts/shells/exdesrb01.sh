#!/bin/ksh
#
# Program Name  : exdesrb01.sh
# Description   : Warehouse exdesrb Extract
#		  Command Line Arguments: None
#                 
#                 Program uses no switches.
# Author        : Janice Lanzo
# Date          : 07/29/15
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: exdesrb01.sh 

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


# Submit exdesrb01 program
submit_exdesrb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/exdesrb01  

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "EXDES00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   EXDES00MAS=${EXDES00MAS}"
echo "   EXDESRB001=${EXDESRB001}"
submit_exdesrb01
date

exit 0
