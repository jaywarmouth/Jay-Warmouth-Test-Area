#!/bin/sh
#
# Program Name  : rbadfrb01.sh
# Description   : Warehouse RBADF00MAS Extract - Full file extract
# Author        : Linda Jefferis
# Date          : 06/13/2018
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

usage: rbadfrb01.sh 

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


# Submit rbadfrb01 program
submit_rbadfrb01()
{
        runcobol ${OBJ_DIR}/rbadfrb01  
	RETVAL=$?
}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "RBADF00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   RBADF00MAS=${RBADF00MAS}"
echo "   RBADFRB001=${RBADFRB001}"
submit_rbadfrb01
date

exit $RETVAL
