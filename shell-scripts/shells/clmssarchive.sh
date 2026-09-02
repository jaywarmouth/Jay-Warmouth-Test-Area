#!/bin/sh
#
#
# Program Name  : clmssarchive.sh
# Author        : Aruna
# Date          : 09/01/2026
#

# Variables Used:
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
BATCHRANGE="AA01A000XL31Z999"
USEPARMS=" "
USEPARMS_FLG=0
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmssarchive.sh -b <batchrange>
        all input parameters are optional:
                -b <batchrange> 

ENDOFUSAGE
  exit 99
}

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

# Submit clmssarchive program
submit_clmssarchive()
{

      runcobol ${OBJ_DIR}/clmssarchive -C /usr/rmcobol/terminfo-d0.cfg -a ${BATCHRANGE}
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

#CLMSS00MAS=/home/amurugan/test/clmss/CLMSS00MAS  
#export CLMSS00MAS

  CLMSS00MASA=/usr/lnk/clmss/CLMSS00MAS-archive-${DATE}
  export CLMSS00MASA


echo "Archive old records in CLMSS File"
date

echo "   RANGE=${BATCHRANGE}"
echo "   CLMSS00MAS=${CLMSS00MAS}"
echo "   CLMSS00MASA=${CLMSS00MASA}"


submit_clmssarchive
date

echo "RETURN_CODE=${RETVAL}"
exit ${RETVAL}
