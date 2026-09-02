#!/bin/ksh
#
# Program Name  : stgdes01.sh
# Description   : Export Step Trigger Description to Warehouse
#		  Command Line Arguments: None
#
#                 Program uses no switches.
# Author        : John Kutchenriter
# Date          : 03/16/2010
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

usage: stgdes01.sh

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


# Submit stgdes01 program
submit_stgdes01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/stgdes01

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_stgdes01
date

exit 0
