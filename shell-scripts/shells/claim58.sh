#!/bin/ksh
#
# Program Name	: claim58.sh
# Description   : Post PHDEM00MAS Independent Code to Claims
#                 Command line arguments:
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay, off, twice, or week cycle - rerun date is period end date
#		  -f <filename> - Assign alternate CLAIM00MAS
#                 -t Test-Mode
# Author	: James Masluk
# Date		: 02/27/2008
# Modifications : 04/02/2008 - Added "-f" option  (LSJ)
#		: 05/07/2008 - Added alternate AUDIT20MAS for week-cycle
#		: 09/24/2009 - Changes for switch to new check run process
#
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
RERUN=0
RERUN_INFO="null"
TEST_MODE=0
FILE_FLAG=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim58.sh [-t] [-b <batch-range><rerun-date"ccyymmdd">]

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

          
# Submit claim58 program
submit_claim58()
{
      runcobol ${OBJ_DIR}/claim58 -s 000${TEST_MODE}${RERUN} -a ${RERUN_INFO}
}

# Cleanup
cleanup ()
{
	if test -a ${CLAIM58MAS}
	then
   		rm ${CLAIM58MAS}
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
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN_INFO=$1
        RERUN=1
        ;;
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

# Stops change updates for RXODS
CHGFILEFLAG=N; export CHGFILEFLAG

CLAIM58MAS=/tmp/CLAIM58MAS
export CLAIM58MAS

AUDIT20MAS=/usr/lnk/audit/CLAIM02
export AUDIT20MAS

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi


echo "Post PHDEM00MAS Independent Code to Claims"
date
submit_claim58 

# Cleanup
echo ""
echo "-> Doing Cleanup"
cleanup


date

exit 0
