#!/bin/sh
#
# Program Name	: permirb01.sh
# Description   : PERMI00MAS extract to warehouse.
#                 Command line arguments:
#           
# Author	: Linda Jefferis
# Date		: 02/23/2017
# Modifications :                                                            
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

usage: permirb01.sh 

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit 01 program
submit_permirb01()
{
     runcobol ${OBJ_DIR}/permirb01  
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Extract of PERMI00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   PERMI00MAS=$PERMI00MAS"
echo "   PERMIRB001=$PERMIRB001"
submit_permirb01
echo "RETVAL=$RETVAL"
date

exit $RETVAL
