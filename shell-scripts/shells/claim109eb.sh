#!/bin/ksh
#
# Program Name	: claim109eb.sh
# Description   : Claims to Tape Transfer for EBI-MedBen(System 49)
#                 Command line arguments:
#                 -c Type of cycle (pay,mon,week,)
#                 -s Skip sort flag
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay or week cycle - rerun date is period end date
#			for mon cycle - rerun date is month end date e.g. 20071031
#                 -t Test-Mode
# Author	: James Masluk
# Date		: 10/24/2007
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

usage: claim109eb.sh [-c pay|mon|week] [-s] [-t] [-b <batch-range><rerun-date"ccyymmdd">]

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

# Assign Alternate environment variables
alt_env()
{
   if [ ${CYCLE} = "null" ]
   then
      usage
   else
      case ${CYCLE} in
        "pay")
           CLAIM109EBKEY=${CLAIM109EBKEY}-P;export CLAIM109EBKEY
           ;;
        "week")
           CLAIM109EBKEY=${CLAIM109EBKEY}-W;export CLAIM109EBKEY
           ;;
        "mon")
           CLAIM109EBKEY=${CLAIM109EBKEY}-M;export CLAIM109EBKEY
      esac
   fi
}
          
# Submit claim109eb program
submit_claim109eb()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim109eb -s ${SKIP_SORT}${PAY}${MON}${WEEK}${TEST_MODE}${RERUN} -a ${RERUN_INFO} 
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


echo "Claims to Tape Transfer - claim109eb"
date
submit_claim109eb 
date

exit 0
