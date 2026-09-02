#!/bin/ksh
#
# Program Name  : claim107.sh
# Description   : Adjustment Creation Program for Payment to Incorrect Provider
#                 Command line arguments:
#                 -f Assign alternate CLAIM00MAS
# Author        : Christina Harris  
# Date          : 12/08/1998
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim107.sh [-f <filename>] 

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

# Submit claim107 program
submit_claim107()
{
  runcobol ${OBJ_DIR}/claim107
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
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
        FILE_FLAG=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]

then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi
 
echo Adjustment Creation Program for Payment to Incorrect Provider
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"

#Submit the programs
submit_claim107

date

