#!/bin/ksh
#
# Program Name	: limit48.sh
# Description   : List cardholders at 75% of limit for Aultman groups  
#                 Command line arguments:
#                 -s Skip sort flag
# Author	: Michael Paulus
# Date		: 09/20/2005
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit48.sh [-s skip_sort]

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

# Submit limit48 program
submit_limit48()
{
   runcobol ${OBJ_DIR}/limit48 -s ${SKIP_SORT} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "List cardholders at 75% of limit for Aultman groups"
date
submit_limit48
date


exit 0
