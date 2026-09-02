#!/bin/ksh
#
# Program Name  : adminrb01.sh
# Description   : Warehouse Admin00Mas File Extract
#		  Command Line Arguments:
# Author        : Mike Paulus
# Date          : 09/09/11
# Modifications : 
#                
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

usage: adminrb01.sh     

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


# Submit adminrb01 program
submit_adminrb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/adminrb01   

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables

echo "ADMIN00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   ADMINRB001=${ADMINRB001}"
submit_adminrb01
date

exit 0
