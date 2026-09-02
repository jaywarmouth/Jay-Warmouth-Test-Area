#!/bin/ksh
#
# Program Name	: claim-pre82.sh
# Description   : System Level Drug Utilization Build for Quarter Report
#                 Command line arguments:
#                 -s Skip Sort     
# Author	: Christina Senediak 
# Date		: 07/11/96
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/pdm/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim-pre82.sh [-s]

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



# Submit claim-pre82 program
submit_claimpre82()
{
   if [ ${SKIP_SORT} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim-pre82 -s 11
     else
        runcobol ${OBJ_DIR}/claim-pre82 -s 01
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
CLAIM81RMAS=/usr/pdm/CLAIM81RMAS
CLAIM81MAS=/usr/lnk/rb_02/CLAIM81MAS
CLAIM82KEY=/usr/pdm/keys/CLAIM82KEY.pre82
export CLAIM81RMAS CLAIM81MAS CLAIM82KEY


echo HSTN Claims for the State
date
submit_claimpre82 
date

exit 0
