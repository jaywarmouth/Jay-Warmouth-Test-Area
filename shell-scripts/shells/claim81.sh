#!/bin/ksh
#
# Program Name	: claim81.sh
# Description   : Key Load for Drug Utilization Quarter Report
#                 Command line arguments:
#                 -s Skip sort flag
#                 -r Rerun 
# Author	: Christina Senediak 
# Date		: 07/08/96
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
RE_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim81.sh [-s] [-r]

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



# Submit claim81 program
submit_claim81()
{
   if [ ${SKIP_SORT} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim81 -s 1${RE_RUN}
     else
        runcobol ${OBJ_DIR}/claim81 -s 0${RE_RUN}
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
    -r) RE_RUN=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
CLAIM81KEY=/usr/lnk/keys/CLAIM81KEY.qrt
export CLAIM81KEY

echo "Key Load for Drug Utilization"
date
submit_claim81 
date

exit 0
