#!/bin/sh
#
#
# Program Name  : COMPBROPREJMAS.CBL
# Date          : 11/21/2023
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var

OBJ_DIR="/usr/lnk/obj"

DATETM=`date +%Y%m%d-%H%M%S`

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


# Submit COMPBROPREJMAS program
submit_COMPBROPREJ()
{
     runcobol ${OBJ_DIR}/COMPBROPREJ

}


#
# Main routine
#
#BROPREJMASO=/usr/devl/users/gsepulveda/test/BROPREJMAS-INIT
BROPREJMASO=${BROPREJMASO}
  export BROPREJMASO


#BROPREJMASN=/usr/devl/users/gsepulveda/test/BROPREJMAS
BROPREJMASN=${BROPREJMASN}
  export BROPREJMASN

#BROPREJMASDIF=/usr/devl/users/gsepulveda/test/BROPREJMAS-COMP-DIFF-${DATETM}
BROPREJMASDIF=${BROPREJMASDIF}
  export BROPREJMASDIF

#LOADTIMES=/usr/lnk/tmp/loadtimesgv
#  export LOADTIMES

echo "COMPARE BROPREJMAS FILES"
date
echo ""
echo "   BROPREJMASO=${BROPREJMASO}"
echo "   BROPREJMASN=${BROPREJMASN}"
echo "   BROPREJMASDIF=${BROPREJMASDIF}"


submit_COMPBROPREJ
date

exit 0
