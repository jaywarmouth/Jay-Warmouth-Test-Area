#!/bin/sh
#
# to run: EXTRONETM00MAS.sh <OUTFILE> <ONETM00MAS>
#
# Program Name  : EXTRONETM00MAS.CBL
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


# Submit EXTRONETM00MAS program
submit_EXTRONETM00MAS()
{
  runcobol ${OBJ_DIR}/EXTRONETM00MAS
}

#
# Main routine
#
# Validate parameters
if [ $# -ne 2 ]
then
    echo "Usage: EXTRONETM00MAS.sh <OUTFILE> <ONETM00MAS>"
    exit 1
fi

parse_env
#
OUTFILE=$1
  export OUTFILE
#ONETM00MAS=$2
ONETM00MAS=dummyfile
  export ONETM00MAS

echo CREATE ONETM00MAS  BINARY EXTRACT
date
echo
echo "   ONETM00MAS=${ONETM00MAS}"
echo "   OUTFILE=${OUTFILE}"


submit_EXTRONETM00MAS
date
