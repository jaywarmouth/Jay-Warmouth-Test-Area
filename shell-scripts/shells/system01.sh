#!/bin/ksh
#
# Program Name  : system01.sh
# Description   : Access SYSTEM File Extract
# Author        : Dave Tucci
# Date          : 08/10/2000
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

usage: system01.sh

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


# Submit system01 program
submit_system01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/system01

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

umask 002

# Assign alternate environment variables

echo ""
echo "SYSTERB001=${SYSTERB001}"
echo ""
rm -f ${SYSTERB001}
date
submit_system01
date

exit 0
