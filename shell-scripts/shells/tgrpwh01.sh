#!/bin/sh
#
# Program Name  : tgrpwh01.sh
# Description   : Warehouse TGRP000MAS Extract - Full file extract
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

usage: tgrpwh01.sh 

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


# Submit tgrpwh01 program
submit_tgrpwh01()
{
        runcobol ${OBJ_DIR}/tgrpwh01  
	RETVAL=$?
}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "TGRP000MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   TGRP000MAS=${TGRP000MAS}"
echo "   TGRPRB0001=${TGRPRB0001}"
submit_tgrpwh01
date

exit $RETVAL
