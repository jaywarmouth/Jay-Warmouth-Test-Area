#!/bin/sh
#
# Program Name	: rejcd01.sh
# Description   : REJCD00MAS extract to warehouse.
#                 Command line arguments:
#           
# Author	: Linda Jefferis
# Date		: 05/23/2018
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

usage: rejcd01.sh 

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
submit_rejcd01()
{
     runcobol ${OBJ_DIR}/rejcd01  
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Extract of REJCD00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   REJCD00MAS=$REJCD00MAS"
echo "   REJCDRB001=$REJCDRB001"
submit_rejcd01
date

exit $RETVAL
