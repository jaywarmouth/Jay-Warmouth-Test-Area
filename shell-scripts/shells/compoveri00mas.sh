#!/bin/sh
#
# to run: COMPOVERI00MAS.jl
#
# Program Name  : COMPOVERI00MAS.CBL
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


# Submit COMPOVERI00MAS program
submit_COMPOVERI00MAS()
{
     runcobol ${OBJ_DIR}/COMPOVERI00MAS

}


#
# Main routine
#
parse_env
#
OVERI00MASO=$1
  export OVERI00MASO

OVERI00MASN=${OVERI00MAS}
  export OVERI00MASN

OVERI00MASDIF=/usr/lnk/wt/benefit-wt/OVERI00-DIFF-${DATETM}
  export OVERI00MASDIF

echo CREATE OVERI00MAS  FILE
date
echo 
echo "   OVERI00MASO=${OVERI00MASO}"
echo "   OVERI00MASN=${OVERI00MASN}"
echo "   OVERI00MASDIF=${OVERI00MASDIF}"


submit_COMPOVERI00MAS
date

exit 0
                                                                                       
