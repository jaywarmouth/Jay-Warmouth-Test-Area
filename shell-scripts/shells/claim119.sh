#!/bin/ksh
#
# Program Name	: claim119.sh
# Description   : Claims to Tape Transfer
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Type of cycle (pay,mon,day,week)
#                 -f <filename> (set different CLAIM00MAS)
#		  -r <batch range><rerun date-ccyymmdd>
#			for pay - rerun date is period ending date
#			for mon - rerun date is month end date
#                       for day - rerun date is any desired date
# Author	: Debbie Wilson             
# Date		: 02/26/01
# Modifications : 05/03/2005 - Changes for new week-cycle  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
FILE_FLAG=0
CYCLE="null"
PAY=0
MONTH=0
WEEK=0
DAY=0
RERUN=0
RERUN_INFO="null"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim119.sh [-c pay,mon,week,day] [-s] [-f <filename>] [-r <batch range><ccyymmdd>]

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
        MONTH=1
        ;;
     "week")
        WEEK=1
        ;;
     "day")
        DAY=1
        ;;
     *)  usage
         ;;
   esac
}


# Submit claim119 program
submit_claim119()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
     runcobol ${OBJ_DIR}/claim119 -s ${SKIP_SORT}${PAY}${MONTH}${WEEK}${DAY}${RERUN} -a ${RERUN_INFO}
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

# Assign alternate environment variables
if [ $DAY = 1 ]
then
   CLAIM119KEY=${CLAIM119KEY}-D;export CLAIM119KEY
fi
if [ $WEEK = 1 ]
then
   CLAIM119KEY=${CLAIM119KEY}-W;export CLAIM119KEY
fi
if [ $PAY = 1 ]
then
   CLAIM119KEY=${CLAIM119KEY}-P;export CLAIM119KEY
fi
if [ $MONTH = 1 ]
then
   CLAIM119KEY=${CLAIM119KEY}-M;export CLAIM119KEY
fi

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS 
fi


echo "Claims to File Transfer - claim119"
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
submit_claim119 
date

exit 0
