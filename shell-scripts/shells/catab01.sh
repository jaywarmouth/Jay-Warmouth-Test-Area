#!/bin/ksh
#
# Program Name	: catab01.sh
# Description   : CATAB00MAS extract to warehouse.
#                 Command line arguments:
#                 -f Complete update(Full-Run)
# Author	: Mike Paulus
# Date		: 11/08/07
# Modifications : 10/19/2012 - Removed logic for special FULL file name
#		: 02/2023 - logic change for how to run FULL file.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FULL_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: catab01.sh [-f]

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

# Submit catab01 program
submit_catab01()
{
     runcobol ${OBJ_DIR}/catab01 -a ${FULL_RUN} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) FULL_RUN=F
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Extract of CATAB00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   CATABRB001=${CATABRB001}"
submit_catab01
date

exit 0
