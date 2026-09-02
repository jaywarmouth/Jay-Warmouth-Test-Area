#!/bin/ksh
#
# Program Name	: claim122.sh
# Description   : Claims to Tape Transfer 
#                 Command line arguments:
#                 -c Type of cycle (pay,qrt)
#                 -s Skip sort flag
#                 -r Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay cycle - rerun date is period end date
# Author	: James Masluk
# Date		: 09/24/02
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
RERUN=0
RERUN_INFO="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim122.sh [-c pay|qrt] [-s] [-r <batch-range><rerun-date"ccyymmdd">]
	-c pay|qrt 	 type of cycle run (required)
	-s               skip sort flag (optional)
	-r <batch-range><rerun-date"ccyymmdd">   batchrange and end date for rerun (optional)

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
     "pay" | "qrt")
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
           CLAIM122KEY=${CLAIM122KEY}.pay;export CLAIM122KEY
           ;;
        "qrt")
           CLAIM122KEY=${CLAIM122KEY}.qrt;export CLAIM122KEY
           ;;
      esac
   fi
}
          
# Submit claim122 program
submit_claim122()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
     case ${CYCLE} in
       "pay")
          echo Pay-Cycle 
          if [ ${RERUN} = 1 ]
          then
	    echo "RERUN INPUT: ${RERUN_INFO}"
            runcobol ${OBJ_DIR}/claim122 -s ${SKIP_SORT}101 -a ${RERUN_INFO}
          else
            runcobol ${OBJ_DIR}/claim122 -s ${SKIP_SORT}100 -a ${RERUN_INFO}
          fi
          ;;
       "qrt")
          echo Qrt-Cycle
          if [ ${RERUN} = 1 ]
          then
            echo "RERUN INPUT: ${RERUN_INFO}"
            runcobol ${OBJ_DIR}/claim122 -s ${SKIP_SORT}011 -a ${RERUN_INFO}
          else
            runcobol ${OBJ_DIR}/claim122 -s ${SKIP_SORT}010 -a ${RERUN_INFO}
          fi
          ;;
     esac
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
    -r) shift
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


echo "Claims to Tape Transfer - CLAIM122"
date
submit_claim122 
date

exit 0
