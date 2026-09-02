#!/bin/ksh
#
# Program Name	: pndesrb01.sh
# Description   : PNDES00MAS extract to warehouse.
#                 Command line arguments:
#           
# Author	: Linda Jefferis
# Date		: 09/22/2014
# Modifications : 7/5/2016 - TT15133-16 (exit coding change) 
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

usage: pndesrb01.sh 

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
submit_pndesrb01()
{
     runcobol ${OBJ_DIR}/pndesrb01  
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Extract of PNDES00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   PNDES00MAS=$PNDES00MAS"
echo "   PNDESRB001=$PNDESRB001"
submit_pndesrb01
date

exit $RETVAL
