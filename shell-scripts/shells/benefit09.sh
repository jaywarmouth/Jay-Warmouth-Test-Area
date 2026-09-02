#!/bin/ksh
#
# Program Name	: benefit09.sh
# Description   : BEN0900MAS KEY PROGRAM
#                 Command line arguments:
# Author	: Debbie Wilson
# Date		: 02/02/01
# Modifications : 09/01/2005 - Added "umask 002" command  (LSJ)
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

usage: benefit09.sh

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

# Submit benefit09 program
submit_benefit09()
{
    runcobol ${OBJ_DIR}/benefit09 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

umask 002

# Assign alternate environment variables

date
submit_benefit09
date

exit 0
