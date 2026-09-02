#!/bin/ksh
#
# Program Name	: clmta01.sh
# Description   : Transitional Assistance Utilitzation Amounts
#                 Systems: 35  Sponsor: 229
#                 Command line arguments:
#                 -s Skip Sort
#		  -b <batch range><m/e date - ccyymmdd>
#                 -t Test Mode - Changes Directory
# Author	: James Masluk
# Date		: 04/21/2004
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/pdm/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
BATCH="                        "
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmta01.sh [-s skip_sort] [-t test_mode] [-b <batch range><m/e date>]
	<m/e date> in ccyymmdd format

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

# Submit clmta01 program
submit_clmta01()
{
   runcobol ${OBJ_DIR}/clmta01 -s ${SKIP_SORT}${TEST_MODE} -a "${BATCH}"  
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
    -t) TEST_MODE=1
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

if [ ${TEST_MODE} = 1 ]
then

   CLMTA01KEY=/usr/lnk/wrk/CLMTA01KEY
     export CLMTA01KEY

   OUTDAT0MAS=/usr/lnk/wrk/OUTDAT0TST
     export OUTDAT0MAS
fi


echo "Monthly TA Amounts for Spo 229"
date
echo

# Submit the program
submit_clmta01 

date

exit 0
