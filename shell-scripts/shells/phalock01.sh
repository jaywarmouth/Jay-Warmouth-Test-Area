#!/bin/ksh
#
# Program Name	: phalock01.sh
# Description   : PHALOCKMAS extract to warehouse.
#                 Command line arguments:
# Author	: DEBBE ADGATE
# Date		: 10/24/2017
# Modifications : 10/30/2017 - TT:12225-96; Changes for production script  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phalock01.sh

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
	  echo "*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit phalock01 program	
submit_phalock01()
{
     runcobol ${OBJ_DIR}/phalock01               
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Extract of PHALOCKMAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   PHALOCKRB1=${PHALOCKRB1}"
echo "   PHALOCKAS=${PHALOCKMAS}"
submit_phalock01

date
echo "RETVAL=$RETVAL"

exit $RETVAL

