#!/bin/ksh
#
# Program Name	: convclm55.sh 
# Description   : Conversion Process For CLAIM55MAS.
#                 Command line arguments:
#                 -f <filename> - path and filename of claim55 file
#                 -n <filename> - path and filename of new converted claim55 file
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

usage: convclm55.sh [-f <filename>] [-n <filename>]

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

# Submit convclm55 program
submit_convclm55()
{
      runcobol ${OBJ_DIR}/convclm55 
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
  CLAIM55MAS=${FILE}
  export CLAIM55MAS
fi
if [ ${NEW_FILE} = "null" ]
then
  usage
else
  CLNEW55MAS=${NEW_FILE}
  export CLNEW55MAS
fi
CLWRK55MAS=/usr/clm_11/CLWRK55MAS
export CLWRK55MAS

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   CLNEW55MAS=$CLNEW55MAS"
echo "   CLWRK55MAS=$CLWRK55MAS"

submit_convclm55
date

exit 0
