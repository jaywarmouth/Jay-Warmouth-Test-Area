#!/bin/ksh
#
# Program Name	: claim109pro.sh
# Description   : Claims Data Feed to Proactive for Worksite Benefits
#                 Command line arguments:
#                 -c Type of cycle (pay,mon,week,twice-month,quarter )
#                 -s Skip sort flag
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay or week cycle - rerun date is period end date
#			for mon cycle - rerun date is month end date e.g. 19990228
#                       for quarter cycle - rerun date is quarter end date
#                 -t Test-Mode
# Author	: Michael Paulus
# Date		: 02/26/2009
# Modifications : 12/14/2009 - John Kutchenriter
#                 Can be run with -b switch alone. Changed for Proactive
#                 Genesis requirment to provide run based on Batch Range and
#                 date (CCYYMMDD) input. Use with the -b switch alone is
#                 required for the GENESIS reports.
#		: 06/17/2017 - TT16965-2; changed runcobol command
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
PRO_ACT=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim109pro.sh [-c pay|twice|mon|week|qua] [-s] [-t] [-b <batch-range><rerun-date"ccyymmdd">]

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
# Check for a Proactive/Gensis Run
check_pro()
{
     if [ ${CYCLE} = "null" ]
     then
        PRO_ACT=1
        RERUN=0
        CYCLE="pro"
     else
        PRO_ACT=0
     fi
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
           CLAIM109PROKEY=${CLAIM109PROKEY}-P;export CLAIM109PROKEY
           ;;
        "week")
           CLAIM109PROKEY=${CLAIM109PROKEY}-W;export CLAIM109PROKEY
           ;;
        "twice")
           CLAIM109PROKEY=${CLAIM109PROKEY}-T;export CLAIM109PROKEY
           ;;
        "mon")
           CLAIM109PROKEY=${CLAIM109PROKEY}-M;export CLAIM109PROKEY
           ;;
         "qua")
           CLAIM109PROKEY=${CLAIM109PROKEY}-Q;export CLAIM109PROKEY
           ;;
         "pro")
           CLAIM109PROKEY=${CLAIM109PROKEY}-G;export CLAIM109PROKEY
      esac
   fi
}

          
# Submit claim109pro program
submit_claim109pro()
{
   if [ $[CYCLE] = "null" ]
   then
        usage
   else
      runcobol ${OBJ_DIR}/claim109pro -a ${SKIP_SORT}${PAY}${TWICE}${MON}${WEEK}${QUARTER}${TEST_MODE}${RERUN}${RERUN_INFO} 

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
        check_pro
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



date


echo "Claims to Tape Transfer - claim109pro"
date
submit_claim109pro 
date

exit 0
