#!/bin/sh
#
# Program Name	: claim130.sh
# Description   : Rebate External Claim Records
#                 Command line arguments:
#                 -s Skip Sort
#                 -r <batch range><rerun enddate - ccyymmdd>
#                 -t Test Mode - Changes Directory
#		  -c <pay|twice|tweek|qrt>
#		  -f <filename> - Assign alternate CLAIM00MAS
#
# Author	: Kathy Ritzler
# Date		: 06/14/2004
# Modifications : 06/06/2007 - Added alternate assigning of CLAIM130KEY  (LSJ)
#               : 10/01/2010 - Added tweek cycle
#		: 08/21/2013 - Added qrt switch logic for history file creation
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"     
SKIP_SORT=0
RERUN_INFO="null"
RERUN=0
TEST_MODE=0
TWICE=0
PAY=0
TWEEK=0
QRT=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim130.sh [-c <pay|twice|tweek|qrt>] [-s skip_sort] [-t test_mode] [-r <batch range><ccyymmdd>] [-f <filename>]

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
     "tweek")
        TWEEK=1
        ;;
     "qrt")
        QRT=1
        ;;
    *)  usage
         ;;

   esac
}


# Submit claim130 program
submit_claim130()
{
   runcobol ${OBJ_DIR}/claim130 -s ${SKIP_SORT}${PAY}${TWICE}${TWEEK}${RERUN}${TEST_MODE}${QRT} -a ${RERUN_INFO}
}

#
# Main routine
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1
        RERUN_INFO=$1
        ;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	CYCLE=$1
	validate_cycle
	;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

#
# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $PAY = 1 ]
then
	CLAIM130KEY=${CLAIM130KEY}-P;export CLAIM130KEY
fi
if [ $TWICE = 1 ]
then
	CLAIM130KEY=${CLAIM130KEY}-T;export CLAIM130KEY
fi
if [ $TWEEK = 1 ]
then
        CLAIM130KEY=${CLAIM130KEY}-X;export CLAIM130KEY
fi
if [ $QRT = 1 ]
then
        CLAIM130KEY=${CLAIM130KEY}-Q;export CLAIM130KEY
fi

if [ $FILE_FLAG = 1 ]
then
	CLAIM00MAS=$FILE; export CLAIM00MAS
fi

if [ ${TEST_MODE} = 1 ]
then

   SYSTE00MAS=/usr/lnk/wrk/SYSTE00TST.cycle
     export SYSTE00MAS

   CLAIM130KEY=/usr/lnk/wrk/CLAIM130KEY
     export CLAIM130KEY

   OUTDAT0MAS=/usr/lnk/wrk/OUTDAT0TST
     export OUTDAT0MAS
fi

echo "Claims to tape transfer transfer - claim130"
date
echo
echo "CLAIM00MAS=$CLAIM00MAS"
echo "CLAIM130KEY=$CLAIM130KEY"

# Submit the program
submit_claim130 

date

exit 0
