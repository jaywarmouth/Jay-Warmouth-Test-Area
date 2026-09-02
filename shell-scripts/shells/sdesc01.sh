#!/bin/ksh
#
# Program Name  : sdesc01.sh
# Description   : Export Step Therapy Description to Warehouse
#		  Command Line Arguments: None
#
#                 Program uses no switches.
# Author        : John Kutchenriter
# Date          : 03/18/2010
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

usage: sdesc01.sh

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


# Submit sdesc01 program
submit_sdesc01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/sdesc01

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_sdesc01
date

exit 0
