#!/bin/ksh
#
# Program Name	: claim109.sh
# Description   : Claims to Tape Transfer 
#                 Command line arguments:
#                 -c Type of cycle (pay,mon,week,twice-month,tweek-cycle )
#                 -s Skip sort flag
#                 -w Week-Option for Twice cycle systems
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay or week cycle - rerun date is period end date
#			for mon cycle - rerun date is month end date e.g. 19990228
# Author	: Linda S. Jefferis
# Date		: 01/21/99
# Modifications :
#  		: 02/15/99 Added rerun switch, batch range and rerun date.
#		: 07/25/2000 - Changed variable BATCH to RERUN_INFO for clarification  (LSJ)
#		: 03/07/2007 - Addition of '-w' option
#		: 12/29/2009 - Assign different KEY name for "-w" option
#               : 10/05/2010 - Add tweek-cycle. (MJP)
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

usage: claim109.sh [-c pay|twice|mon|week|tweek] [-s] [-w] [-b <batch-range><rerun-date"ccyymmdd">]

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
           CLAIM109KEY=${CLAIM109KEY}-P;export CLAIM109KEY
           ;;
        "week")
           CLAIM109KEY=${CLAIM109KEY}-W;export CLAIM109KEY
           ;;
        "twice")
	   if [ ${TW_RUN} = 1 ]
	   then
		CLAIM109KEY=${CLAIM109KEY}-X;export CLAIM109KEY
	   else
           	CLAIM109KEY=${CLAIM109KEY}-T;export CLAIM109KEY
	   fi
           ;;
        "mon")
           CLAIM109KEY=${CLAIM109KEY}-M;export CLAIM109KEY
           ;;
        "tweek")
           CLAIM109KEY=${CLAIM109KEY}-X;export CLAIM109KEY
	   ;;
      esac
   fi
}
          
# Submit claim109 program
submit_claim109()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim109 -s ${SKIP_SORT}${PAY}${TWICE}${MON}${WEEK}${TWEEK}${TW_RUN}${RERUN} -a ${RERUN_INFO}  
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

echo "Claims to Tape Transfer - claim109"
date
submit_claim109 
date

exit 0
