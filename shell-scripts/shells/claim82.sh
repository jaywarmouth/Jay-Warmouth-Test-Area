#!/bin/ksh
#
# Program Name	: claim82.sh
# Description   : Drug Utilization Report                     
#                 Command line arguments:
#                 -s Skip sort flag
# Author	: Christina Senediak 
# Date		: 07/11/96
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim82.sh [-s] [-r]

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


# Submit claim82 program
submit_claim82()
{
   if [ ${SKIP_SORT} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim82 -s 11
     else
        runcobol ${OBJ_DIR}/claim82 -s 01
   fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate variables
CLAIM81MAS=/usr/pdm/CLAIM81RMAS
export CLAIM81MAS


echo Drug Utilization Report   
date
submit_claim82 
date

exit 0
