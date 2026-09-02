#!/bin/ksh
#
# Program Name	: convclm56.sh 
# Description   : Conversion Process For CLAIM56MAS.
#                 Command line arguments:
#                 -f <filename> - path and filename of claim56 file
#                 -n <filename> - path and filename of new converted claim56 file
# Author	: Dave Tucci
# Date		: 04/09/99
# Modifications : 06/10/99 - Added command line arguments  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE="null"
NEW_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convclm56.sh [-f <filename>] [-n <filename>]

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

# Submit convclm56 program
submit_convclm56()
{
      runcobol ${OBJ_DIR}/convclm56 
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
  CLAIM56MAS=${FILE}
  export CLAIM56MAS
fi
if [ ${NEW_FILE} = "null" ]
then
  usage
else
  CLNEW56MAS=${NEW_FILE}
  export CLNEW56MAS
fi
CLWRK56MAS=/usr/clm_11/CLWRK56MAS
export CLWRK56MAS

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   CLNEW56MAS=$CLNEW56MAS"
echo "   CLAIM56MAS=$CLAIM56MAS"

submit_convclm56
date

exit 0
