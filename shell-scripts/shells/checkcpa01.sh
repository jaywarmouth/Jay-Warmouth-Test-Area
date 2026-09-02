#!/bin/ksh
#
# Program Name  : checkcpa01.sh
# Description   : Call cpa01 to get PA code for input in calling program.
#                 COmmand line arguements: NONE
#
# Author        : John Kutchenriter
# Date          : 06/09/2010
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

usage: checkcpa01.sh

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



# Submit chksumtst program
submit_checkcpa01()
{
        runcobol ${OBJ_DIR}/checkcpa01
}

#
# Main routine
#


# Parse environment variables
parse_env


date
submit_checkcpa01
date

exit 0

