#!/bin/sh
#
# to run: COMPCAGRPXWMAS.jl
#
# Program Name  : COMPCAGRPXWMAS.CBL
# Author        : J.Lanzo
# Date          : 4/23/2025
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


# Submit COMPCAGRPXWMAS program
submit_COMPCAGRPXWMAS()
{
     runcobol ${OBJ_DIR}/COMPCAGRPXWMAS D
}


#
# Main routine
#
CAGRPXWMASO=${CAGRPXWMAS}
  export CAGRPXWMASO

CAGRPXWMASN=${CAGRPXWMAS}
  export CAGRPXWMASN

CAGRPXWMASDIF=/usr/lnk/wt/benefit-wt/CAGRPXW-DIFF-${DATETM}
  export CAGRPXWMASDIF
#LOADTIMES=/usr/lnk/tmp/loadtimesgv
#  export LOADTIMES

echo CREATE SPONS00MAS FILE
date
echo ""
echo "   CAGRPXWMASO=${CAGRPXWMASO}"
echo "   CAGRPXWMASN=${CAGRPXWMASN}"
echo "   CAGRPXWMASDIF=${CAGRPXWMASDIF}"


submit_COMPCAGRPXWMAS
date

exit 0
