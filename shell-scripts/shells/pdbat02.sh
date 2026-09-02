#!/bin/ksh
#
# Program Name  : pdbat02.sh
# Description   : Upload Batches To PDBAT00MAS for New Check Cycle
#                 Command line arguements:
#                 None
# Author        : J Kutchenriter
# Date          : 11/23/2009
# Modifications : 
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

usage: pdbat02.sh

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



# Submit pdbat02 program
submit_pdbat02()
{

        runcobol ${OBJ_DIR}/pdbat02

}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables


date
submit_pdbat02
date

exit 0
