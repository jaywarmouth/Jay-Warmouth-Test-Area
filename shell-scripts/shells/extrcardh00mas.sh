#!/bin/sh
#
# to run: EXTRCARDH00MAS.sh <OUTFILE> <CARDH00MAS>
#
# Program Name  : EXTRCARDH00MAS.CBL
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


# Submit EXTRCARDH00MAS program
submit_EXTRCARDH00MAS()
{
     runcobol ${OBJ_DIR}/EXTRCARDH00MAS
}

#
# Main routine
#
# Validate parameters
if [ $# -ne 2 ]
then
    echo "Usage: EXTRCARDH00MAS.sh <OUTFILE> <CARDH00MAS>"
    exit 1
fi

parse_env
#
OUTFILE=$1
  export OUTFILE
#CARDH00MAS=$2
CARDH00MAS=dummyfile
  export CARDH00MAS

echo CREATE CARDH00MAS BINARY EXTRACT
date
echo
echo "   CARDH00MAS=${CARDH00MAS}"
echo "   OUTFILE=${OUTFILE}"


submit_EXTRCARDH00MAS
date
