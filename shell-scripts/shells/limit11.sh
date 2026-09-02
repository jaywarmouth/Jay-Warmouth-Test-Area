#!/bin/ksh
#
# Program Name	: limit11.sh
# Description   : Recalculate Limits by Group
#                 Command line arguments:
# Author	: Dave Tucci
# Date		: 03/31/98
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

usage: limit11.sh

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


# Submit limit11 program
submit_limit11()
{
        runcobol ${OBJ_DIR}/limit11
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

date
submit_limit11 
date

exit 0
