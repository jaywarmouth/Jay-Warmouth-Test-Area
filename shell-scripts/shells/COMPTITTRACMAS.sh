#!/bin/ksh
#
# Program Name  : COMPTITTRACMAS.sh
# Description   : run COMPTITTRACMAS 
# Author        : Bill Swidal
# Date          : 06/21/2022
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: COMPTITTRACMAS.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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


#
# Main routine
#

# Parse environment variables
parse_env

#echo "TITTRACMAS=${TITTRACMAS}"

# Check command line validity, call usage if incorrect
DEBUG=" "
VERS="curr"

while [ $# -gt 0 ]
do
  case "$1"
  in
    -D) DEBUG="D"
        ;;
    -P) VERS="prev"
        ;;
  esac
  shift
done

# Assign alternate environment variables

# comment out the first 2 and change the 3rd one to the desired production directory
TITTRACMASO=/usr/lnk/grp/TITTRACMAS  #${TITTRACMAS}
export TITTRACMASO

TITTRACMASN=/usr/lnk/grp/TITTRACMAS  #${TITTRACMAS}
export TITTRACMASN

TITTRACMASDIF=./TITTRACMASDIF
export TITTRACMASDIF



echo "Compare old/new TITTRACMAS"  
echo "TITTRACMASO=${TITTRACMASO}"
echo "TITTRACMASN=${TITTRACMASN}"
echo "TITTRACMASDIF=${TITTRACMASDIF}"
date
echo press Return
read dummy

if [ $VERS = "prev" ]
then
    runcobol ${PREV_OBJ_DIR}/COMPTITTRACMAS
else
    runcobol ${OBJ_DIR}/COMPTITTRACMAS ${DEBUG}
fi

date
exit 0
