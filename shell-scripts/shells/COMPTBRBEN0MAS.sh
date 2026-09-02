#!/bin/ksh
#
# Program Name  : COMPTBRBEN0MAS.sh
# Description   : run COMPTBRBEN0MAS 
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

usage: COMPTBRBEN0MAS.sh 

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

#echo "TBRBEN0MAS=${TBRBEN0MAS}"

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
TBRBEN0MASO=/usr/lnk/grp/TBRBEN0MAS  #${TBRBEN0MAS}
export TBRBEN0MASO

TBRBEN0MASN=/usr/lnk/grp/TBRBEN0MAS  #${TBRBEN0MAS}
export TBRBEN0MASN

TBRBEN0MASDIF=./TBRBEN0MASDIF
export TBRBEN0MASDIF



echo "Compare old/new TBRBEN0MAS"  
echo "TBRBEN0MASO=${TBRBEN0MASO}"
echo "TBRBEN0MASN=${TBRBEN0MASN}"
echo "TBRBEN0MASDIF=${TBRBEN0MASDIF}"
date
echo press Return
read dummy

if [ $VERS = "prev" ]
then
    runcobol ${PREV_OBJ_DIR}/COMPTBRBEN0MAS
else
    runcobol ${OBJ_DIR}/COMPTBRBEN0MAS ${DEBUG}
fi

date
exit 0
