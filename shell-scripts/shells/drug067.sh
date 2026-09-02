#!/bin/ksh
#
# Program Name  : drug067.sh
# Description   : Update Type Code 67 With Data From Type Code 1, 2, or 3
#		  Command Line Arguments:
#                 -f Assign alternate DRUG067TAP
#
# Author        : James Masluk
# Date          : 02/19/04
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

usage: drug067.sh [-f <filename>]

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


# Submit drug067 program
submit_drug067()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drug067 

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
   DRUG067TAP=${FILE}
   export DRUG067TAP
fi


echo "Update Type Code 67"
echo "DRUG067TAP=$DRUG067TAP"
date
submit_drug067 
date

exit 0
