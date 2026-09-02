#!/bin/ksh
#
# Program Name  : pharm03.sh
# Description   : Access PHDEM File Extract
# Author        : Dave Tucci
# Date          : 08/11/2000
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

usage: pharm03.sh

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


# Submit pharm03 program
submit_pharm03()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/pharm03

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
echo "PHARMRB001=${PHARMRB001}"
echo ""
rm -f ${PHARMRB001}
date
submit_pharm03
date

exit 0
