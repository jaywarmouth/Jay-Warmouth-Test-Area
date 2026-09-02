#!/bin/ksh
#
# Program Name	: claim109d0.sh
# Description   : Claims to Tape Transfer(New version for NCPDP D.0) 
#                 Command line arguments:
#                 -c Type of cycle (pay,mon,week,twice-month,tweek-cycle )
#                 -s Skip sort flag
#                 -w Week-Option for Twice cycle systems
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay or week cycle - rerun date is period end date
#			for mon cycle - rerun date is month end date e.g. 19990228
# Author	: Michael Paulus
# Date		: 02/01/2011
# Modifications :


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
TW_RUN=0
TWEEK=0
RERUN=0
RERUN_INFO="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim109d0.sh [-c pay|twice|mon|week|tweek] [-s] [-w] [-b <batch-range><rerun-date"ccyymmdd">]

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
     "tweek")
        TWEEK=1
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
           CLAIM109D0KEY=${CLAIM109D0KEY}-P;export CLAIM109D0KEY
           ;;
        "week")
           CLAIM109D0KEY=${CLAIM109D0KEY}-W;export CLAIM109D0KEY
           ;;
        "twice")
	   if [ ${TW_RUN} = 1 ]
	   then
		CLAIM109D0KEY=${CLAIM109D0KEY}-X;export CLAIM109D0KEY
	   else
           	CLAIM109D0KEY=${CLAIM109D0KEY}-T;export CLAIM109D0KEY
	   fi
           ;;
        "mon")
           CLAIM109D0KEY=${CLAIM109D0KEY}-M;export CLAIM109D0KEY
           ;;
        "tweek")
           CLAIM109D0KEY=${CLAIM109D0KEY}-X;export CLAIM109D0KEY
	   ;;
      esac
   fi
}
          
# Submit claim109d0 program
submit_claim109d0()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim109d0 -s ${SKIP_SORT}${PAY}${TWICE}${MON}${WEEK}${TWEEK}${TW_RUN}${RERUN} -a ${RERUN_INFO}   
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
    -w) TW_RUN=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
alt_env

echo "Claims to Tape Transfer - claim109d0"
date
submit_claim109d0 
date

exit 0
