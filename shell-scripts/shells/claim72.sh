#!/bin/ksh
#
# Program Name	: claim72.sh
# Description   : Claims to Tape Transfer 
#                 Command line arguments:
#                 -c Type of cycle (pay,mon,week)
#                 -s Skip sort flag
#                 -r Rev-filename flag
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#               : 02/12/97 - Removed proc_audit logic - LSJ
#                 03/21/97 - Added env_var & OBJ_DIR logic - LSJ
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CYCLE="null"
SKIP_SORT=0
REV=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim72.sh [-c pay|mon|week] [-s] [-r] 

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
     "pay" | "mon" | "week")
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
           CLAIM72KEY=${CLAIM72KEY}.pay;export CLAIM72KEY
           ;;
        "week")
           if [ ${REV} = 1 ]
           then
              CLAIM72KEY=${CLAIM72KEY}.wkrev;export CLAIM72KEY
              CLAIM00MAS=tmp/CLWRK00MAS.wkrev;export CLAIM00MAS
           else
              CLAIM72KEY=${CLAIM72KEY}.wk;export CLAIM72KEY
           fi
           ;;
      esac
   fi
}
          
# Submit claim72 program
submit_claim72()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
     case ${CYCLE} in
       "pay")
          echo Pay-Cycle - HSNC
          if [ ${SKIP_SORT} = 1 ]
          then
            runcobol ${OBJ_DIR}/claim72 -s 1100${REV}
          else
            runcobol ${OBJ_DIR}/claim72 -s 0100${REV}
          fi
          ;;
       "mon")
          echo Month-end:  PRM MBM
          if [ ${SKIP_SORT} = 1 ]
          then
            runcobol ${OBJ_DIR}/claim72 -s 1010${REV}
          else
            runcobol ${OBJ_DIR}/claim72 -s 0010${REV}
          fi
          ;;
       "week")
          echo Week-Cycle:  PRM
          runcobol ${OBJ_DIR}/claim72 -s ${SKIP_SORT}001${REV}
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
    -r) REV=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
alt_env

echo Claims to Tape Transfer
date
submit_claim72 
date

exit 0
