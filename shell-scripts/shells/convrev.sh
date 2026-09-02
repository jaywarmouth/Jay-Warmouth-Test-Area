#!/bin/ksh
#
# Program Name	: convrev.sh 
# Description   : Conversion Process For REVER00MAS.
#                 Command line arguments:
#                 -f <filename> - path and filename of reversal file
#                 -n <filename> - path and filename of new converted reversal file
# Author	: Dave Tucci
# Date		: 02/04/99
# Modifications : 06/10/99 - Added command line arguments  (LSJ)
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

usage: convrev.sh [-f <filename>] [-n <filename>]

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

# Submit convrev program
submit_convrev()
{
      runcobol ${OBJ_DIR}/convrev
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
  REVER00MAS=${FILE}
  export REVER00MAS
fi
if [ ${NEW_FILE} = "null" ]
then
  usage
else
  REVER99MAS=${NEW_FILE}
  export REVER99MAS
fi


echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   REVER00MAS=${REVER00MAS}"
echo "   REVER99MAS=${REVER99MAS}"
submit_convrev
date

exit 0
