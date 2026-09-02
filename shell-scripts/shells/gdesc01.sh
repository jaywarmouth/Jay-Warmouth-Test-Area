#!/bin/sh
#
# Program Name  : gdesc01.sh
# Description   : Redbrick GDESC00MAS File Extract
#		  Command Line Arguments:
#		    none to this point
#                 Exports whole file
# Author        : John Kutchenriter
# Date          : 12/24/2009
# Modifications : 09/30/2015 - add "-f" logic
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FULL_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gdesc01.sh -f
	-f is to set switch for full file extract

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit gdesc01 program
submit_gdesc01()
{
	runcobol ${OBJ_DIR}/gdesc01 -a ${FULL_FLG}
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) FULL_FLG=1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

date
echo "EXPORT PATHS:"
echo "   GDESC00MAS=$GDESC00MAS"
echo "   GDESCRB001=$GDESCRB001"
submit_gdesc01
date

exit 0
