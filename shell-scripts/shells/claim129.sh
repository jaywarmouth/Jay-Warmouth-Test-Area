#!/bin/ksh
#
# Program Name	: claim129.sh
# Description   : Claims to Tape Transfer 
#                 Command line arguments:
#                 -c Type of cycle (pay,week,twice,mon)
#                 -s Skip sort flag
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay or week cycle - rerun date is period end date
#			for mon cycle - rerun date is month end date e.g. 19990228
#                 -t Test Mode
# Author	: Kathy Ritzler    
# Date		: 06/04/04
# Modifications :
#                 Test Mode - 10/06/04 (JM)
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CYCLE="null"
SKIP_SORT=0
TEST_MODE=0
RERUN=0
RERUN_INFO="null"
PAY=0
TWICE=0
MON=0
WEEK=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim129.sh [-t] [-c pay|week|twice|mon] [-s] [-b <batch-range><rerun-date"ccyymmdd">]

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
# Validate -c options
validate_cycle()
{  case ${CYCLE} in
     "pay")
        PAY=1
        ;;
     "twice")
        TWICE=1
        ;;
     "mon")
        MON=1
        ;;
     "week")
        WEEK=1
        ;;
    *)  usage
         ;;

   esac
}

# Submit claim129 program
submit_claim129()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim129 -s ${SKIP_SORT}${PAY}${WEEK}${TWICE}${MON}${TEST_MODE}${RERUN} -a ${RERUN_INFO}
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        validate_cycle
        ;;
    -s) SKIP_SORT=1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
CLAIM129KEY=$CLAIM129KEY.${CYCLE}
export CLAIM129KEY

echo "Claims to Tape Transfer - claim129"
date
echo "   CLAIM29KEY=$CLAIM129KEY"
submit_claim129 
date

exit 0
