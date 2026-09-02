#!/bin/ksh
#
# Program Name  : limit23.sh
# Description   : Recalculate Year End Rollover's
# Author        : Christina Harris
# Date          : 12/19/97
# Modifications :
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/po/misc
TIME=`date +%T`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit23.sh 

ENDOFUSAGE
  exit 1
}
#
#Parse environment variables file
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

# Submit limit23 program
submit_limit23()
{
        runcobol ${OBJ_DIR}/limit23
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_limit23
date

exit 0


