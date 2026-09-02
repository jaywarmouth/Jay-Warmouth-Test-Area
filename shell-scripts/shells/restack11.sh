#!/bin/ksh
#
# to run: restack11.sh
#
# Program Name	: restack11.sh
# Description   : Send Cardholder Restack file to the warehouse
#		  Full file extract
#                 Command line arguments:
#                   none
#             
# Author	: Peggy Voytilla
# Date		: 10/19/2012
# Modifications : 12/06/2012 - LSJ - Updates prior to making production 
#		: 
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

usage: restack11.sh

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

	
# Run program
submit_restack11()
{
      runcobol ${OBJ_DIR}/restack11   
}

#
# Main routine
#
# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Send Cardholder Restack file to warehouse"
date
echo "EXPORT PATHS:"
echo "   RESTK00MAS=$RESTK00MAS"
echo "   RESTKRB001=$RESTKRB001"

submit_restack11
date


exit 0
