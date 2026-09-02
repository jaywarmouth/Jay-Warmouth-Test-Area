#!/bin/ksh
#
# Program Name	: claim131.sh
# Description   : Claims to Tape Transfer 
#                 Command line arguments:
#                 -c Type of cycle (twice-month )
#                 -s Skip sort flag
#                 -b Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for twice-month cycle - rerun date is period end date
# Author	: Michael Paulus   
# Date		: 04/29/2008
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CYCLE="null"
SKIP_SORT=0
TWICE=0
RERUN=0
RERUN_INFO="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim131.sh [-c twice] [-s]  [-b <batch-range><rerun-date"ccyymmdd">]

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
        "twice")
           CLAIM131KEY=${CLAIM131KEY}-T;export CLAIM131KEY
           ;;
      esac
   fi
}
          
# Submit claim131 program
submit_claim131()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim131 -s ${SKIP_SORT}${TWICE}${RERUN} -a ${RERUN_INFO} 
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
alt_env

echo "Claims to Tape Transfer - claim131"
date
submit_claim131 
date

exit 0
