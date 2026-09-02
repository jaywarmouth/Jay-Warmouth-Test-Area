#!/bin/sh
#
# Program Name	: dtms04.sh
# Description	: 
# Author	: Linda S. Jefferis
# Date		: 04/16/97
# Modifications :  
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

usage: dtms04.sh 

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

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

echo "DTMS04 - Creation of CLKDC00MAS"
date
runcobol ${OBJ_DIR}/dtms04 
date

exit 0
