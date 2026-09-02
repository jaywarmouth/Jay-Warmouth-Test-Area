#!/bin/ksh
#
# Program Name  : claim178.sh
# Description   : Trial Card Claim To Tape Transfer
#		  Command Line Arguments:
#                 -s Skip sort flag
#                 -c Type of cycle (twice)
#                 -r <batch range><rerun date-ccyymmdd>
#                 -l Line Numbers
#                 -t Test Mode (Demo)
#
# Author        : James Masluk
# Date          : 01/20/05
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
LINE_NUM=0000
TEST_MODE=0
SKIP_SORT=0
FILE_FLAG=0
CYCLE="twice"
RERUN_INFO="null"
RERUN=0
TWICE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim178.sh [-s] [-c twice] [-r <batch range><ccyymmdd>] [-t] [-l <line number>] [-f <filename>] 
        -c twice                   type of cycle run (required)
        -s                         skip sort flag (optional)
        -f filename                to use optional input claims file (optional)
        -r <batchrange><ccyymmdd>  batchrange and end date for rerun (optional)
        -l line numbers            queue numbers for real time processing. ("-l 0000" required for rerun option)

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

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

#
# Submit claim178 program
submit_claim178()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
     if [ ${RERUN} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim178 -s ${SKIP_SORT}${TWICE}${RERUN}${TEST_MODE} -a ${LINE_NUM}${RERUN_INFO}  
     else
        runcobol ${OBJ_DIR}/claim178 -s ${SKIP_SORT}${TWICE}${RERUN}${TEST_MODE} -a ${LINE_NUM} 
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
    -s) SKIP_SORT=1
        ;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        validate_cycle
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1
        RERUN_INFO=$1
        ;;
    -t) TEST_MODE=1
        ;;
    -l) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        LINE_NUM=$1
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
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

if [ ${TEST_MODE} = 1 ]
then
   CLAIM178KEY=/usr/lnk/wrk/CLAIM178KEY
     export CLAIM178KEY

   OUTDAT0MAS=/usr/lnk/wrk/OUTDAT0TST
     export OUTDAT0MAS
fi


echo "Trial Card Claim To Tape Transfer"
date
submit_claim178 
date

exit 0
