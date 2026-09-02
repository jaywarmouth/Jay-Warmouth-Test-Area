#!/bin/ksh
#
# Program Name	: spons01.sh
# Description   : SPONS00MAS extract to warehouse.
#                 Command line arguments:
# Author	: Mike Paulus
# Date		: 04/01/2011
# Modifications :                                                            
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
OUTPUT_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: spons01.sh 

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

# Submit spons01 program
submit_spons01()
{
     runcobol ${OBJ_DIR}/spons01                 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Extract of SPONS00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   SPONSRB001=${SPONSRB001}"
submit_spons01
date

exit 0
