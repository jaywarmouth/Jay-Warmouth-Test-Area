#!/bin/ksh
#
# Program Name	: claim55.sh
# Description   : Incurred Claims Update of CLAIM55MAS 
#                 Command line arguments:
#                 -c Type of run (pay or twice or week or mon)
#                 -m Load-Month-option flag
#                 -y Load-Year-option flag
#                 -s Skip sort flag
#                 -f Assign Alternate CLAIM55MAS 
# Author	: Linda S. Jefferis
# Date		: 08/23/96
# Modifications : 03/28/97 - Added env_var & OBJ_DIR logic
#                 03/28/97 - Removed proc_audit
#                 12/03/04 - Added twice-month cycle (DW)
#                 12/03/04 - Deleted re-run cycle    (DW)
#                 04/28/05 - Added week-month cycle (DW)
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
LOAD_MON=0
LOAD_YR=0
CLEAR_MON=0
ARGUMENT=""
FILE_FLAG=0
MON=0
PAY=0
TWICE=0
WEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim55.sh [-c pay|twice|week|mon] [-m] [-y] [-s] [-f <filename>]

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
        OFF=1
        ;;
     "twice")
        TWICE=1
        ;;
     "week")
        WEEK=1
        ;;
     *)  usage
	 ;;
   esac
}

# Submit claim55 program
submit_claim55()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
     runcobol ${OBJ_DIR}/claim55_weekcycle -s ${LOAD_MON}${LOAD_YR}${CLEAR_MON}${SKIP_SORT}${MON}${PAY}${TWICE}${WEEK}
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
    -m) LOAD_MON=1
        CLEAR_MON=1
        ;;
    -y) LOAD_YR=1
        ;;
    -s) SKIP_SORT=1
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

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM55MAS=${FILE}
   export CLAIM55MAS
else
   CLAIM55MAS=/usr/lnk/claims/CLAIM55MAS.${CYCLE}
   export CLAIM55MAS
fi
if [ $PAY = 1 ]
then
   CLAIM55KEY=$CLAIM55KEY-P;export CLAIM55KEY
fi
if  [ $TWICE = 1 ]
then
   CLAIM55KEY=$CLAIM55KEY-T;export CLAIM55KEY
fi
if  [ $WEEK = 1 ]
then
   CLAIM55KEY=$CLAIM55KEY-W;export CLAIM55KEY
fi
if  [ $MON = 1 ]
then
   CLAIM55KEY=$CLAIM55KEY-M;export CLAIM55KEY
fi

echo Incurred Claims Update of CLAIM55MAS
date
echo "EXPORT PATHS:"
echo "   CLAIM55MAS=$CLAIM55MAS"
submit_claim55 
date

exit 0
