#!/bin/sh
#
# Program Name	: vrxbprb01.sh
# Description   : Extract VRXBP00MAS for load to warehouse         
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

usage: vrxbprb01.sh

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

	
# Submit vrxbprb01 program
submit_vrxbprb01()
{
      runcobol ${OBJ_DIR}/vrxbprb01 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect


# Parse environment variables
parse_env


echo "EXTRACT VRXBP00MAS TO LOAD TO WAREHOUSE"

date
echo "EXPORT PATHS:"
echo "   VRXBP00MAS=$VRXBP00MAS"
echo "   VRXBPRB001=$VRXBPRB001"

submit_vrxbprb01

date

exit $RETVAL
