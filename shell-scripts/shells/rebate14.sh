#!/bin/ksh
#
# Program Name	: rebate14.sh
# Description   : ESI Rebate Report
#                 Command line arguments:
#                 -s Skip Sort
#                 -g <begendgrouprange> - total of 32-digits
#		  -b <startstopbatchrange> - total of 16-chars.
# Author	: James Masluk
# Date		: 06/21/2002
# Modifications : 
#                 09/04/02 - Change Group Numbers To 16 Digits Each. (JM)
#
# Variables Used:
ENV_FILE=/usr/pdm/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
GROUP=0
BATCH=""

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebate14.sh [-s skip_sort] [-g "BegEndGroupRange"] [-b "StartStopBatchRange"]

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

# Submit rebate14 program
submit_rebate14()
{
   runcobol ${OBJ_DIR}/rebate14 -s ${SKIP_SORT} -a "${GROUP}${BATCH}" 
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
    -g) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        GROUP=$1
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
submit_rebate14 

date

exit 0
