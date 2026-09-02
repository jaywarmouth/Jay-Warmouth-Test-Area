#!/bin/ksh
#
# Program Name	: claim83ghc.sh
# Description   : Claims Data Feed to Proactive for Worksite Benefits
#                 Command line arguments:
#                 -c Type of cycle (mon,tweek )
#                 -s Skip sort flag
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for mon cycle - rerun date is month end date e.g. 19990228
# Author	: Michael Paulus
# Date		: 04/18/2011
# Modifications : 
#               : Can be run with -b switch alone. Changed for Proactive
#                 requirment to provide run based on Batch Range and
#                 date (CCYYMMDD) input. Use with the -b switch alone is
#                 required for the Proactive reports.
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
MON=0
TWEEK=0
RERUN=0
RERUN_INFO="null"
PRO_ACT=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim83ghc.sh [-c mon|tweek] [-s] [-b <batch-range><rerun-date"ccyymmdd">]

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
# Check for a Proactive Run
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
     "mon")
        MON=1
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
        "tweek")
           CLAIM83GHCKEY=${CLAIM83GHCKEY}-W;export CLAIM83GHCKEY
           ;;
        "mon")
           CLAIM83GHCKEY=${CLAIM83GHCKEY}-M;export CLAIM83GHCKEY
           ;;
         "pro")
           CLAIM83GHCKEY=${CLAIM83GHCKEY}-G;export CLAIM83GHCKEY
      esac
   fi
}

          
# Submit claim83ghc program
submit_claim83ghc()
{
   if [ $[CYCLE] = "null" ]
   then
        usage
   else
      runcobol ${OBJ_DIR}/claim83ghc -s ${SKIP_SORT}${MON}${TWEEK}${RERUN} -a ${RERUN_INFO} 

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

  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
alt_env



date


echo "Claims to Tape Transfer - claim83ghc"
date
submit_claim83ghc 
date

exit 0
