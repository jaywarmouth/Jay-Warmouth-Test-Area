#!/bin/sh
#
# Program Name  : ndcinc01.sh
# Description   : Warehouse NDCINC0MAS Extract - Full file extract
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

usage: ndcinc01.sh 

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


# Submit ndcinc01 program
submit_ndcinc01()
{
        runcobol ${OBJ_DIR}/ndcinc01  
	RETVAL=$?
}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "NDCINC0MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   NDCINC0MAS=${NDCINC0MAS}"
echo "   NDCINCRB001=${NDCINCRB001}"
submit_ndcinc01
date

exit $RETVAL
