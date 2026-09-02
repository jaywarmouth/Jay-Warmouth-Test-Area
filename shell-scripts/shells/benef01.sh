#!/bin/sh
#
# Program Name	: benef01.sh
# Description   : BENEF00MAS extract to warehouse.
#                 Command line arguments: none
# Author	: Bill Swidal
# Date		: 11/11/2016
# Modifications :                                                            
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
OUTPUT_FILE="null"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: benef01.sh 

ENDOFUSAGE
#  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."
}

# Submit spons01 program
submit_benef01()
{
     runcobol ${OBJ_DIR}/benef01
     RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables (RB normally to $SQLIMPORTS/misc/)
# normal path: $SQLIMPORTS/misc/BENEFRB001 where SQLIMPORTS=/usr/lnk/sqlimports

echo "Extract of BENEF00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   BENEF00MAS=${BENEF00MAS}"
echo "   BENEFRB001=${BENEFRB001}"

submit_benef01
date

exit ${RETVAL}
