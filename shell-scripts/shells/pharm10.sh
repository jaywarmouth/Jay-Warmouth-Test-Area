#!/bin/ksh
#
# Program Name  : pharm10.sh
# Description   : Initial pharmacy network load
# Author        : David Tucci
# Date          : 11/04/97
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pharm10.sh 

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


# Submit pharm10 program
submit_pharm10()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/pharm10

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
date
submit_pharm10
date

exit 0
