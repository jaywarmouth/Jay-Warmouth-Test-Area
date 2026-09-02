#!/bin/ksh
#
# Program Name	: claim109gran.sh
# Description   : Claims data file for ABC/Granville (spo1048)
#                 Command line arguments:
#                 -c Type of cycle (pay|week|twice)
#                 -s Skip sort flag
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay or week cycle - rerun date is period end date
#			for mon cycle - rerun date is month end date e.g. 19990228
#                       for quarter cycle - rerun date is quarter end date
#                 -f <CLAIM filename>
#                 -t Test-Mode
# Author	: Michael Paulus
# Date		: 02/02/2011
# Modifications : 2/18/2019 - TT18858-47; add twice-cycle logic.
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
WEEK=0
TWICE=0
RERUN=0
RERUN_INFO="null"
TEST_MODE=0
FILE_FLAG=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim109gran.sh [-c pay|week|twice] [-s] [-t] [-b <batch-range><rerun-date"ccyymmdd">] -f <filename>

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
     "week")
        WEEK=1
        ;;
     "twice")
        TWICE=1
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
           CLAIM109GRANKEY=${CLAIM109GRANKEY}-P;export CLAIM109GRANKEY
           ;;
        "week")
           CLAIM109GRANKEY=${CLAIM109GRANKEY}-W;export CLAIM109GRANKEY
           ;;
        "twice")
           CLAIM109GRANKEY=${CLAIM109GRANKEY}-T;export CLAIM109GRANKEY
           ;;
      esac
   fi
   if [ ${FILE_FLAG} = 1 ]
   then
        CLAIM00MAS=${FILE}
        export CLAIM00MAS
   fi
}
          
# Submit claim109gran program
submit_claim109gran()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim109gran -s ${SKIP_SORT}${PAY}${TWICE}0${WEEK}0${TEST_MODE}${RERUN} -a ${RERUN_INFO}  
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
alt_env

echo "Claims to Tape Transfer - claim109gran"
date
submit_claim109gran 
date

exit 0
