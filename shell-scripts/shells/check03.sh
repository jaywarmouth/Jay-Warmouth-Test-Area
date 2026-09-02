#!/bin/ksh
#
# Program Name	: check03.sh 
# Description   : Outstanding check run
#                 Command line arguments:
# Author	: Dave Tucci
# Date		: 11/04/99
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

usage: check03.sh

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

# Submit check03 program
submit_check03()
{
      runcobol ${OBJ_DIR}/check03
}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables

echo Conversion Process
date
echo "EXPORT PATHS:"

submit_check03
date

lpp /usr/lnk/misc/CHECK03-RPT

exit 0
