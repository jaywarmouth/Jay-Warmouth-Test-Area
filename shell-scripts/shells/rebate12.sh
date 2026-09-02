#!/bin/ksh
#
# Program Name	: rebate12.sh
# Description   : ESI Rebates
#                 Systems: 2
#                 Command line arguments:
#		  -b <startstopbatchrange>
# Author	: James Masluk
# Date		: 12/31/2001
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/pdm/shell/env_var
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

usage: rebate12.sh [-s skip_sort] [-b "StartStopBatchRange"]

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

# Submit rebate12 program
submit_rebate12()
{
   runcobol ${OBJ_DIR}/rebate12 -s ${SKIP_SORT} -a "${BATCH}"  
}

#
# Main routine
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

#
# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Claims Extracts for ESI/AMS"
date
echo

# Submit the program
submit_rebate12 

date

exit 0
