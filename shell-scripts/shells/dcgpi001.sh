#!/bin/ksh
#
# Program Name  : dcgpi001.sh
# Description   : DCGPI Tape Load
# Author        : David Tucci
# Date          : 08/04/99
# Modifications : 02/11/2008 - Commented out the "lp" of the reports  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/po/misc
USER=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dcgpi001.sh 

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


# Submit dcgpi001 program
submit_dcgpi001()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/dcgpi001 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env


# Assign alternate environment variables
MSDCA=/usr/upd/dosecheck/MSDCA
export MSDCA

echo " MSDCA=$MSDCA"
echo " DCGPI=$DCGPI"

rm -f ${PRINT_DIR}/DCGPI-ADD-RPT
rm -f ${PRINT_DIR}/DCGPI-CHANGE-RPT
date
submit_dcgpi001
#lp ${PRINT_DIR}/DCGPI-ADD-RPT
#lp ${PRINT_DIR}/DCGPI-CHANGE-RPT
date

exit 0
