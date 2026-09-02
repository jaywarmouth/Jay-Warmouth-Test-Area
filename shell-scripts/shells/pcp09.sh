#!/bin/ksh
#
# Program Name	: pcp09.sh
# Description   : PCP0100MAS KEY PROGRAM
#                 Command line arguments:
# Author	: Dave Tucci
# Date		: 03/01/98
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
BATCH=""

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pcp09.sh

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

# Submit pcp09 program
submit_pcp09()
{
    runcobol ${OBJ_DIR}/pcp09
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_pcp09 
date

exit 0
