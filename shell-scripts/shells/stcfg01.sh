#!/bin/ksh
#
# Program Name	: stcfg01.sh
# Description   : STCFG00MAS extract to warehouse.
#                 Command line arguments:
# Author	: Patrick Murphy
# Date		: 03/11/2024
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
exit 0

usage: stcfg01.sh 

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

# Submit stcfg01 program
submit_stcfg01()
{
     runcobol ${OBJ_DIR}/stcfg01                 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Extract of STCFG00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   STCFGRB001=${STCFGRB001}"
echo "   STCFG00MAS=${STCFG00MAS}"
submit_stcfg01
date
