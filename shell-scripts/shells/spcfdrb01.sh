#!/bin/ksh
#
# Program name  : spcfdrb01.sh
# Description   : Warehouse SPCFDS0MAS Full File Extract
#                 Command Line Arguments: None
#                 Program uses no switches
# Author        : William Swidal
# Date          : 11/12/2015
# Modifications : 12/4/2015 - updates for production version (LSJ)
#                

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: spcfdrb01.sh     

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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


# Submit sptdsrb01 program
submit_spcfdrb01()
{
        runcobol ${OBJ_DIR}/spcfdrb01  
        RETVAL="$?"
}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "SPCFDS0MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   SPCFDS0MAS=${SPCFDS0MAS}"
echo "   SPCFDSRB01=${SPCFDSRB01}"
submit_spcfdrb01
date

exit ${RETVAL}

