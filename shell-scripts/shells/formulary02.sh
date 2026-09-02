#!/bin/ksh
#
# Program Name  : formulary02.sh
# Description   : CAQH Formulary Data File Creation Program (Monthly)
# Author        : Christina Harris 
# Date          : 02/28/02
# Modifications : 12/06/2005 - Changed path for output files  (LSJ)                
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

usage: formulary02.sh 

ENDOFUSAGE
  exit 1
}

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


# Submit formulary02 program
submit_formulary02()
{
        runcobol ${OBJ_DIR}/formulary02 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

DRUGWRKMAS=/usr/upd/drug/DRUGWRKMAS
export DRUGWRKMAS

FORM100TAP=/usr/lnk/tmp/FORM100TAP
FORM200TAP=/usr/lnk/tmp/FORM200TAP
export FORM100TAP FORM200TAP

date
echo ""
echo "   FORM100TAP=$FORM100TAP"
echo "   FORM200TAP=$FORM200TAP"
echo ""
submit_formulary02
date

rm -f $DRUGWRKMAS

exit 0
