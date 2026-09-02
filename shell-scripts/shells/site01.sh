#!/bin/ksh
#
# Program Name	: site01.sh
# Description   : SITE000MAS extract to warehouse.
#                 Command line arguments:
#                 -f Complete update(Full-run)
#                 Note: program will do a full run with or
#                       without the flag.
# Author	: John Kutchenriter
# Date		: 07/15/2010
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
RUNTYPE=F

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: site01.sh [-f]

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

# Submit site01 program
submit_site01()
{
     runcobol ${OBJ_DIR}/site01 -a ${RUNTYPE} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) RUNTYPE=F
        ;;
  esac
  shift
done

# Parse environment variables
parse_env


echo "Extract of SITE000MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   SITERB001=${SITERB001}"
submit_site01
date

    

exit 0

