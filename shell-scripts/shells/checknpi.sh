#!/bin/ksh
#
# Program Name  : checknpi.sh
# Description   : PROGRAM TO TEST NPI'S
#                 Command line arguments:
# Author        : Sean Romigh
# Date          : 03/14/07
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: checknpi.sh

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

# Submit checknpi program
submit_checknpi()
{
   runcobol ${OBJ_DIR}/checknpi 
}

#
# Main routine
# 
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Program to check NPI's"
date
submit_checknpi  
date


exit 0

