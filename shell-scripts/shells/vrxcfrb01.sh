#!/bin/sh
#
# Program Name	: vrxcfrb01.sh
# Description   : Extract VRXCF00MAS for load to warehouse         
#		  
# Author	: Linda Jefferis     
# Date		: 01/09/2017
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: vrxcfrb01.sh

ENDOFUSAGE
  exit 1
}


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

	
# Submit vrxcfrb01 program
submit_vrxcfrb01()
{
      runcobol ${OBJ_DIR}/vrxcfrb01 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect


# Parse environment variables
parse_env


echo "EXTRACT VRXCF00MAS TO LOAD TO WAREHOUSE"

date
echo "EXPORT PATHS:"
echo "   VRXCF00MAS=$VRXCF00MAS"
echo "   VRXCFRB001=$VRXCFRB001"

submit_vrxcfrb01

date

exit $RETVAL
