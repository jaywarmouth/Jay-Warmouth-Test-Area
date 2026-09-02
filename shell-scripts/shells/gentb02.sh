#!/bin/ksh
#
# Program Name	: gentb02.sh
# Description   : GENTB00MAS extract to warehouse.
#                 Command line arguments:
#                 -f Complete update(Full-Run)
# Author	: Mike Paulus
# Date		: 11/08/07
# Modifications :                                                            
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

usage: gentb02.sh [ -s ] [-f]

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

# Submit gentb02 program
submit_gentb02()
{
     runcobol ${OBJ_DIR}/gentb02 -s ${FULL_RUN}  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) FULL_RUN=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Extract of GENTB00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   GENTBRB001=${GENTBRB001}"
submit_gentb02
date

exit 0
