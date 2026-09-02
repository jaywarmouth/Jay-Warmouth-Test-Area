#!/bin/ksh
#
# Program Name  : drug033.sh
# Description   : DPS NDC Search by Name
# Author        : Debbie Wilson    
# Date          : 09/10/99
#                
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

usage: drug034.sh 

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


# Submit drug034 program
submit_drug034()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drug034 

}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables

date

submit_drug034
date

exit 0
