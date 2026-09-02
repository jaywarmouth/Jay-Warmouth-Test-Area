#!/bin/ksh
#
# Program Name	: rebate01.sh
# Description   : Cigna Rebate File Creation
#                 Command line arguments:
#                 -s Skip sort flag
#                 -b Start & Stop Batch
# Author	: Christina Harris  
# Date		: 12/22/97
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
BATCH=""

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebate01.sh [-s] [-b "StartStopBatchRange"]

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#

# Submit rebate01 program
submit_rebate01()
{
  if [ ${SKIP_SORT} = 1 ]
     then
        runcobol ${OBJ_DIR}/rebate01 -s 1 -a "${BATCH}"
  else
        runcobol ${OBJ_DIR}/rebate01 -s 0 -a "${BATCH}"
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
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCH=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_rebate01 
date

exit 0
