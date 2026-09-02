#!/bin/ksh
#
# Program Name	: pcp80.sh     
# Description	: Physician Membership Load
# Author	: Debbie Wilson 
# Date		: 03/05/99
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pcp80.sh               

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
# Submit pcp80 program
submit_pcp80()
{
   runcobol ${OBJ_DIR}/pcp80
}

# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo Physician Membership Load

date
submit_pcp80
date

exit 0
