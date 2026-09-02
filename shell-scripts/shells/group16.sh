#!/bin/ksh
#
# Program Name  : group16.sh
# Description   : System, Sponsor, Group Count
# Author        : D. Tucci
# Date          : 09/27/99
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

usage: group16.sh  

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


# Submit group16 program
submit_group16()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/group16 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

date

submit_group16
date

lp /usr/lnk/po/misc/PRINT-GROUP16


exit 0
