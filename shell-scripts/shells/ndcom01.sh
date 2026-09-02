#!/bin/sh
#
# Program Name  : ndcom01.sh
# Description   : Warehouse NDCOM00MAS Extract - Full file extract
# Author        : Linda Jefferis
# Date          : 11/20/2017
# Modifications :
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

usage: ndcom01.sh 

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


# Submit ndcom01 program
submit_ndcom01()
{
        runcobol ${OBJ_DIR}/ndcom01  
	RETVAL=$?
}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "NDCOM00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   NDCOM00MAS=${NDCOM00MAS}"
echo "   NDCOMRB001=${NDCOMRB001}"
submit_ndcom01
date

exit $RETVAL
