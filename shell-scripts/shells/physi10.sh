#!/bin/ksh
#
# Program Name  : physi10.sh
# Description   : Physician file IND/GRP flag update for system 35
# Author        : Dave Tucci
# Date          : 05/25/2000
# Modifications : 09/07/2001 - Added display of program name  (LSJ)
#		: 07/20/2005 - Addition of "umask 002" command  (LSJ)
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

usage: physi10.sh

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


# Submit physi10 program
submit_physi10()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/physi10

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

umask 000

# Assign alternate environment variables

echo "PHYSI10 - SummaCare"
date
submit_physi10
date

exit 0
