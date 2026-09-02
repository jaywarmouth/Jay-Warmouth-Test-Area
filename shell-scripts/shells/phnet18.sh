#!/bin/ksh
#
# Program Name  : phnet18.sh
# Description   : Update PHNET00MAS From AGELITYMAS File
#		  Command Line Arguments:
#                 -f Assign alternate AGELITYMAS
#
# Author        : James Masluk
# Date          : 04/13/04
# Modifications : 
#                
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

usage: phnet18.sh [-f <filename>]

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


# Submit phnet18 program
submit_phnet18()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet18  

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
        FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
   AGELITYMAS=${FILE}
   export AGELITYMAS
fi

echo "Updating PHNET00MAS"
date
submit_phnet18 
date

exit 0
