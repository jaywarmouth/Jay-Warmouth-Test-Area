#!/bin/sh
#
#
# Program Name  : clcobarchive.sh
# Author        : Aruna 
# Date          : 09/01/2026
#

# Variables Used:
OBJ_DIR="/usr/lnk/obj"
ENV_FILE=/usr/lnk/shell/env_var
RETVAL=0
BATCHRANGE="AA01A000XL31Z999"
USEPARMS=" "
USEPARMS_FLG=0
CR="
"
EQUAL="="

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clcobarchive.sh -b <batchrange>
                -b <batchrange>

ENDOFUSAGE
  exit 99
}

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

# Submit clcobarchive program
submit_clcobarchive()
{

      runcobol ${OBJ_DIR}/clcobarchive  -a ${BATCHRANGE}
	RETVAL=$?

}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	BATCHRANGE=$1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

DATE=$(date +%Y%m%d)

#CLCOB00MAS=/home/amurugan/test/clcob/CLCOB00MAS  
#export CLCOB00MAS

 CLCOB00MASA=/usr/lnk/claims/CLCOB00MAS-Archive-${DATE}
 export CLCOB00MASA


echo "Archive old records in CLCOB File"
date

echo "   RANGE=${BATCHRANGE}"
echo "   CLCOB00MAS=${CLCOB00MAS}"
echo "   CLCOB00MASA=${CLCOB00MASA}"


submit_clcobarchive
date

echo "RETURN_CODE=${RETVAL}"
exit ${RETVAL}
