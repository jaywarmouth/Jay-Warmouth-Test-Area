#!/bin/sh
#
# Program Name  : gdrsd01.sh
# Description   : Extract GDRSD00MAS data for Warehouse
#                 Exports whole file
# Author        : Tony Krynicky
# Date          : 09/21/2017
# Modifications : 12/08/2017 - Changes for produciton version. 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gdrsd01.sh 
	
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


# Submit gdrsd01 program
submit_gdrsd01()
{
	runcobol ${OBJ_DIR}/gdrsd01 
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


date
echo "EXPORT PATHS:"
echo "   GDRSD00MAS=$GDRSD00MAS"
echo "   GDRSDRB001=$GDRSDRB001"
submit_gdrsd01
date

echo "RET_CODE=$RETVAL"

exit $RETVAL
