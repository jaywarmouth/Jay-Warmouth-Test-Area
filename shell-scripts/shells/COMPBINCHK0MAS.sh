#!/bin/sh
#
# to run: COMPBINCHK0MAS.jl
#
# Program Name  : COMPBINCHK0MAS.CBL
# Author        : J.Lanzo
# Date          : 4/30/2025
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


# Submit COMPBINCHK0MAS program
submit_COMPBINCHK0MAS()
{
     runcobol ${OBJ_DIR}/COMPBINCHK0MAS D

}


#
# Main routine
#
BINCHK0MASO=${BINCHK0MAS}
  export BINCHK0MASO

BINCHK0MASN=${BINCHK0MAS}
  export BINCHK0MASN

BINCHK0MASDIF=/usr/lnk/wt/benefit-wt/BINCHK0-DIFF-${DATETM}
  export BINCHK0MASDIF
#LOADTIMES=/usr/lnk/tmp/loadtimesgv
#  export LOADTIMES

echo CREATE SPONS00MAS FILE
date
echo ""
echo "   BINCHK0MASO=${BINCHK0MASO}"
echo "   BINCHK0MASN=${BINCHK0MASN}"
echo "   BINCHK0MASDIF=${BINCHK0MASDIF}"


submit_COMPBINCHK0MAS
date

exit 0
                                                                                       
