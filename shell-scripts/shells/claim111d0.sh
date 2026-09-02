#!/bin/ksh
#
# Program Name	: claim111d0.sh
# Description   : Claims to Tape Transfer
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Type of cycle (pay,mon,week,day,qrt,twice,tweek)
#                 -f <filename> (set different CLAIM00MAS)
#		  -r <batch range><rerun date-ccyymmdd>
#			for pay - rerun date is period ending date
#			for mon - rerun date is month end date
#                       for day - rerun date is any desired date (JM)
# Author	: Linda Jefferis
# Date		: 11/9/2011
# Modification  : 07/26/2013 - added logic for tweek option
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
FILE_FLAG=0
CYCLE="null"
RERUN_INFO="null"
RERUN=0
PAY=0
MON=0
DAY=0
WEEK=0
TWICE=0
QRT=0
TWEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim111d0.sh [-c pay,mon,week,day,qrt,twice,tweek] [-s] [-f <filename>] [-r <batch range><ccyymmdd>]
	-c pay|mon|day   type of cycle run (required)
	-s		 skip sort flag (optional)
	-f filename	 to use optional input claims file (optional)
	-r <batchrange><ccyymmdd>  batchrange and end date for rerun (optional)

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
     "day")
	DAY=1
	;;
     "mon")
	MON=1
	;;
     "qrt")
	QRT=1
	;;
     "twice")
	TWICE=1
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


# Submit claim111d0 program
submit_claim111d0()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
     if [ ${RERUN} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim111d0 -s ${SKIP_SORT}${PAY}${MON}${WEEK}${DAY}${QRT}${TWICE}${RERUN} -a ${RERUN_INFO}
     else
        runcobol ${OBJ_DIR}/claim111d0 -s ${SKIP_SORT}${PAY}${MON}${WEEK}${DAY}${QRT}${TWICE}${RERUN}
     fi
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1 
        FILE=$1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1 
        RERUN_INFO=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

umask 002

# Assign alternate environment variables
if  [ $PAY = 1 ]
then
   CLAIM111KEY=${CLAIM111KEY}-D0-P;export CLAIM111KEY
fi
if  [ $DAY = 1 ]
then
   CLAIM111KEY=${CLAIM111KEY}-D0-D;export CLAIM111KEY
fi
if  [ $TWICE = 1 ]
then
   CLAIM111KEY=${CLAIM111KEY}-D0-T;export CLAIM111KEY
fi
if  [ $WEEK = 1 ]
then
   CLAIM111KEY=${CLAIM111KEY}-D0-W;export CLAIM111KEY
fi
if  [ $MON = 1 ]
then
   CLAIM111KEY=${CLAIM111KEY}-D0-M;export CLAIM111KEY
fi
if  [ $QRT = 1 ]
then
   CLAIM111KEY=${CLAIM111KEY}-D0-Q;export CLAIM111KEY
fi
if  [ $TWEEK = 1 ]
then
   CLAIM111KEY=${CLAIM111KEY}-D0-X;export CLAIM111KEY
fi
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS 
fi

echo "Claims to File Transfer - CLAIM111"
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
submit_claim111d0 
date

exit 0

