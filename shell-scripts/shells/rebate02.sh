#!/bin/ksh
#
# Program Name	: rebate02.sh
# Description   : BAS Rebate File Creation for Walgreens. (Quarterly Run)
#                 Command line arguments:
#                 -b Start & Stop Batch
# Author	: Christina Harris  
# Date		: 12/16/98
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

usage: rebate02.sh [-b "StartStopBatchRange"]

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

# Submit rebate02 program
submit_rebate02()
{
    runcobol ${OBJ_DIR}/rebate02 -a "${BATCH}"
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
        BATCH=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_rebate02 
date

exit 0
