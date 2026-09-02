#!/bin/sh
#
# to run: EXTRCAWCA00MAS.sh <OUTFILE> <CAWCA00MAS>
#
# Program Name  : EXTRCAWCA00MAS.CBL
# Author        : sgupta
# Date          : 4/30/2026
# T02920 - 05/12/2026 - SG - EXTRONETM00MAS,extronetm00mas,EXTRCATAB00MAS,extrcatab00mas,EXTRCAWCA00MAS,extrcawca00mas,EXTRCARDH00MAS,extrcardh00mas,CARDH29,ELGRT03,cardh29,elgrt03 - Parallel testing for Eligibility batch / RTE load in RDS (Phase 1) -(TD-14954) - 581
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


# Submit EXTRCAWCA00MAS program
submit_EXTRCAWCA00MAS()
{
     runcobol ${OBJ_DIR}/EXTRCAWCA00MAS
}

#
# Main routine
#
# Validate parameters
if [ $# -ne 2 ]
then
    echo "Usage: EXTRCAWCA00MAS.sh <OUTFILE> <CAWCA00MAS>"
    exit 1
fi

parse_env
#
OUTFILE=$1
  export OUTFILE
#CAWCA00MAS=$2
CAWCA00MAS=dummyfile
  export CAWCA00MAS

echo CREATE CAWCA00MAS BINARY EXTRACT
date
echo
echo "   CAWCA00MAS=${CAWCA00MAS}"
echo "   OUTFILE=${OUTFILE}"


submit_EXTRCAWCA00MAS
date
