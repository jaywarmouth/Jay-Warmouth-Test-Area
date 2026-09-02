#!/bin/sh
#
# Program Name	: rejmsg01.sh 
# Description   : REJMSG0MAS extract to warehouse (full file extract).  
#                 Command line arguments:
#                 
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

usage: rejmsg01.sh 

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

# Submit rejmsg01 program
submit_rejmsg01()
{
        runcobol ${OBJ_DIR}/rejmsg01
        RETVAL=$?
}
	
#
# Main routine
#

# Parse environment variables
parse_env

echo "REJMSG0MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "  REJMSG0MAS=$REJMSG0MAS"
echo "  REJMSGRB001=$REJMSGRB001"
submit_rejmsg01
date

exit $RETVAL
