#!/bin/ksh
#
# Program Name	: claim132.sh
# Description   : Claims to Tape Transfer for Trinity 
#                 Command line arguments:
#                 -c Type of cycle (pay)
#                 -s Skip sort flag
#		  -t Test Mode flag (use in tandem with "-b")
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#
# Author	: Michael Paulus   
# Date		: 10/09/2008
# Modifications : 02/03/2012 - Added TEST_MODE option
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
RERUN=0
RERUN_INFO="null"
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim132.sh [-c pay] [-s] [-t] [-b <batch-range><rerun-date"ccyymmdd">]

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
           CLAIM132KEY=${CLAIM132KEY}-P;export CLAIM132KEY
           ;;
      esac
   fi
}
          
# Submit claim132 program
submit_claim132()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim132 -s ${SKIP_SORT}${PAY}${TEST_MODE}${RERUN} -a ${RERUN_INFO} 
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
    -t) TEST_MODE=1
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
alt_env


echo "Claims to Tape Transfer - claim132"
date
submit_claim132 
date

exit 0
