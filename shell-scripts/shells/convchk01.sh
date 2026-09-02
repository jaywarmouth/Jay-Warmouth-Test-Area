#!/bin/ksh
#
# Program Name  : convchk01.sh
# Description   : Redbrick GROUP File Extract
# Author        : Dave Tucci
# Date          : 06/26/98
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/misc
USER=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convchk01.sh

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


# Submit convchk01 program
submit_convchk01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/convchk01 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
CHECK00NEW=/usr/upd/claims/CHECK00NEW
export CHECK00NEW

date
submit_convchk01
date

exit 0
