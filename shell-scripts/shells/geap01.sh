#!/bin/ksh
#
# Program Name	: geap01.sh
# Description   : GEAP000MAS extract to warehouse.
#                 Command line arguments:
#                 -f Complete update(Full-Run)
# Author	: John Kutchenriter
# Date		: 08/24/2010
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

usage: geap01.sh [-f]

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

# Submit geap01 program
submit_geap01()
{
     runcobol ${OBJ_DIR}/geap01 -s ${FULL_RUN}  
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


echo "Extract of GEAP000MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "	 GEAP000MAS=${GEAP000MAS}"
echo "   GEAPRB001=${GEAPRB001}"
submit_geap01
date

exit 0
