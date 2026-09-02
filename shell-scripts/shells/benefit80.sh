#!/bin/ksh
#
# Program Name	: benefit80.sh
# Description   : LOAD BEN8000MAS Membership       
#                 Command line arguments:
# Author	: Deborah L. Wilson
# Date		: 03/05/02
# Modification	: 09/01/2005 - Added "umask 002" command  (LSJ)
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

usage: benefit80.sh 

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

# Submit benefit80n program
submit_benefit80()
{
        runcobol ${OBJ_DIR}/benefit80 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

umask 002

# Assign alternate environment variables

echo "Benefit 80 Membership Load  "
date

submit_benefit80

date

exit 0
