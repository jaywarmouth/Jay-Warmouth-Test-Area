#!/bin/ksh
#
# Program Name	: claim109ihs.sh
# Description   : Claims to Tape Transfer for Ennis(System 76)
#                 Command line arguments:
#                 -c Type of cycle (pay,mon,week,twice-month,quarter )
#                 -s Skip sort flag
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay or week cycle - rerun date is period end date
#			for mon cycle - rerun date is month end date e.g. 19990228
#                       for quarter cycle - rerun date is quarter end date
#                 -t Test-Mode
# Author	: Michael Paulus
# Date		: 03/18/2008
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
MON=0
TWICE=0
WEEK=0
QUARTER=0
RERUN=0
RERUN_INFO="null"
TEST_MODE=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim109ihs.sh [-c pay|twice|mon|week|qua] [-s] [-t] [-b <batch-range><rerun-date"ccyymmdd">]

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
     "qua")
        QUARTER=1
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
           CLAIM109IHSKEY=${CLAIM109IHSKEY}-P;export CLAIM109IHSKEY
           ;;
        "week")
           CLAIM109IHSKEY=${CLAIM109IHSKEY}-W;export CLAIM109IHSKEY
           ;;
        "twice")
           CLAIM109IHSKEY=${CLAIM109IHSKEY}-T;export CLAIM109IHSKEY
           ;;
        "mon")
           CLAIM109IHSKEY=${CLAIM109IHSKEY}-M;export CLAIM109IHSKEY
           ;;
         "qua")
           CLAIM109IHSKEY=${CLAIM109IHSKEY}-Q;export CLAIM109IHSKEY
      esac
   fi
}
          
# Submit claim109ihs program
submit_claim109ihs()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim109ihs -s ${SKIP_SORT}${PAY}${TWICE}${MON}${WEEK}${QUARTER}${TEST_MODE}${RERUN} -a ${RERUN_INFO}
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
alt_env

echo "Claims to Tape Transfer - claim109ihs"
date
submit_claim109ihs 
date

exit 0
