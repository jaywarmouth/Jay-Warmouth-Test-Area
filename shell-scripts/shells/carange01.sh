#!/bin/ksh
#
# Program Name  : carange01.sh
# Description   : Warehouse CARANGEMAS File Extract
#		  Command Line Arguments:
# Author        : DEBBE ADGATE
# Date          : 08/02/16
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

usage: carange01.sh 

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


# Submit carange01 program
submit_carange01()
{
        runcobol ${OBJ_DIR}/carange01
	RETVAL=$?

}

#
# Main routine
#

# Parse environment variables
parse_env


echo "Extract of CARANGEMAS file for Warehouse"
echo "   CARANGERB1=${CARANGERB1}"
echo "   CARANGEMAS=${CARANGEMAS}"
submit_carange01
date

exit $RETVAL
