#!/bin/sh
#
# Program Name  : spectbrb01.sh
# Description   : Warehouse SPECTBRB01 Extract - Full file extract
#		  Command Line Arguments: None
#                 
#                 Program uses no switches.
# Author        : Janice Lanzo
# Date          : 06/05/15
# Modifications : Changes for production version
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

usage: spectbrb01.sh 

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


# Submit spectbrb01 program
submit_spectbrb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/spectbrb01  
	RETVAL="$?"
}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "SPECTB0MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   SPECTB0MAS=${SPECTB0MAS}"
echo "   SPECTBRB001=${SPECTBRB001}"
submit_spectbrb01
date

exit 0
