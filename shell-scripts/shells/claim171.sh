#!/bin/ksh
#
# Program Name	: claim171.sh
# Description   : Claims to Tape Transfer for System 71
#                 Command line arguments:
#                 -c Type of cycle (pay,month )<month requires -m option>
#                 -s Skip sort flag
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay or week cycle - rerun date is period end date
#			for mon cycle - rerun date is month end date e.g. 19990228
#                 -m Calendar Month Run with Batch Range and Run Date
#                 -t Test-Mode
# Author	: Michael Paulus
# Date		: 01/18/2006
# Modifications :
#
#
#
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CYCLE="null"
SKIP_SORT=0
PAY=0
MONTH=0
RERUN=0
BATCH_INFO="null"
TEST_MODE=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim171.sh [-c pay|twice|month] [-s] [-t] [-b <batch-range><rerun-date"ccyymmdd">] [-m <batch range><run-date"ccyymmdd">]

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
     "month")
        MONTH=1
        ;;
    *)  usage
         ;;

   esac
}

# Assign Alternate environment variables
alt_env()
{
   if [ ${CYCLE} = "null" ]
   then
      usage
   else
      case ${CYCLE} in
        "pay")
           CLAIM117KEY=${CLAIM171KEY}-P;export CLAIM171KEY
           ;;
        "month")
           CLAIM171KEY=${CLAIM171KEY}-M;export CLAIM171KEY
      esac
   fi
}
          
# Submit claim171 program
submit_claim171()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim171 -s ${SKIP_SORT}${PAY}${MONTH}${RERUN}${TEST_MODE} -a ${BATCH_INFO}   
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
        BATCH_INFO=$1
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
    -m) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCH_INFO=$1
        MONTH=1
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
alt_env

echo "Claims to Tape Transfer - claim171"
date
submit_claim171 
date

exit 0
