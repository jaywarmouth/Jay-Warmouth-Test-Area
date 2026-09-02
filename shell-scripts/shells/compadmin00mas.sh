#!/bin/sh
#
# to run: COMPADMIN00MAS.fl
#  
# Program Name  : COMPADMIN00MAS.CBL
# Author        : F.Lim
# Modifications : 20251027
#               : T02754 - 11/04/2025 - FL - COMPADMIN00MAS.CBL,IADMIN00MAS.CBL 
#               : PDMI 2025 - ADMIN00MAS - Halo 75800 - 
#               : Add new fee fields - compare & Init programs(initialize to 0) -(TD-12158/75800) - 555
#               : This script will replace the existing file COMPADMIN00MAS.sh


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


# Submit COMPADMIN00MAS program
submit_COMPADMIN00MAS()
{
     runcobol ${OBJ_DIR}/COMPADMIN00MAS

}


#
# Main routine
#
ADMIN00MASO=/usr/lnk/grp/ADMIN00MAS.20251105
  export ADMIN00MASO

ADMIN00MASN=/usr/lnk/grp/ADMIN00MAS
  export ADMIN00MASN

ADMIN00MASDIF=/usr/lnk/tmp/ADMIN00-DIFF-${DATETM}
  export ADMIN00MASDIF




date
echo ""
echo "   ADMIN00MASO=${ADMIN00MASO}"
echo "   ADMIN00MASN=${ADMIN00MASN}"
echo "   ADMIN00MASDIF=${ADMIN00MASDIF}"


submit_COMPADMIN00MAS
date

exit 0
