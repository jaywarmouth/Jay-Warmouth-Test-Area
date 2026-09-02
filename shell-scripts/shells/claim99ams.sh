#!/bin/ksh
#
# Program Name	: CLAIM99.COB
# Description	: Claims for AMS
# Author	: Dave Tucci
# Date		: 08/17/98
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

usage: claim99.ams

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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

rm /usr/upd/claims/CLWRK00MAS.ams

CLWRK00MAS=/usr/upd/claims/CLWRK00MAS.ams

export CLWRK00MAS

runcobol ${OBJ_DIR}/claim99

exit 0
