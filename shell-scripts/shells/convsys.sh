#!/bin/ksh
#
# Program Name	: convsys.sh 
# Description   : Conversion Process For PHYSI00MAS.
#                 Command line arguments:
#		  -f <filename> - path and filename of system file
#                 -n <filename> - path and filename of new converted system file
# Author	: Dave Tucci
# Date		: 12/15/98
# Modifications : 05/07/99 - Added command line arguments  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/pdm/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/programs/obj"
FILE="null"
NEW_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convsys.sh [-f <filename>] [-n <filename>]

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

# Submit convsys program
submit_convsys()
{
      runcobol ${OBJ_DIR}/convsys
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        ;;
    -n) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        NEW_FILE=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE} = "null" ]
then
  usage
else
  SYSTE00MAS=${FILE}
  export SYSTE00MAS
fi
if [ ${NEW_FILE} = "null" ]
then
  usage
else
  SYSTE99MAS=${NEW_FILE}
  export SYSTE99MAS
fi

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   SYSTE00MAS=${SYSTE00MAS}"
echo "   SYSTE99MAS=${SYSTE99MAS}"

submit_convsys
date

exit 0
