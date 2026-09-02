#!/bin/sh
#
# to run: COMPCABIN00MAS.fl
#  
# Program Name  : COMPCABIN00MAS.CBL
# Author        : F.Lim
# Date          : 9/23/2025
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


# Submit COMPCABIN00MAS program
submit_COMPCABIN00MAS()
{
     runcobol ${OBJ_DIR}/COMPCABIN00MAS D

}


#
# Main routine
#
CABIN00MASO=$1
  export CABIN00MASO

CABIN00MASN=${CABIN00MAS}
  export CABIN00MASN

CABIN00MASDIF=/usr/lnk/wt/benefit-wt/CABIN00-DIFF-${DATETM}
  export CABIN00MASDIF



echo CREATE CABIN00MAS FILE
date
echo ""
echo "   CABIN00MASO=${CABIN00MASO}"
echo "   CABIN00MASN=${CABIN00MASN}"
echo "   CABIN00MASDIF=${CABIN00MASDIF}"


submit_COMPCABIN00MAS
date

exit 0
