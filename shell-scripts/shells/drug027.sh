#!/bin/ksh
#
# Program Name	: drug027.sh
# Description   : Update Drug Type Codes
# Author	: John Kutchenriter
# Date		: 08/10/2010
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

usage: drug027.sh

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


# Submit drug027 program
submit_drug027()
{
        runcobol ${OBJ_DIR}/drug027 
 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Updates Expanded OTC's "
date
submit_drug027 
date

exit 0
