#!/bin/ksh
#
# Program Name  : clmrt01.sh
# Description   : Real Time Claim To Tape Transfer
#		  Command Line Arguments:
#                 -c Type of cycle (twice,pay,week)
#                 -r <batch range><rerun date-ccyymmdd>
#                 -l Line Numbers
#                 -t Test Mode (Demo)
#                 -v version 5010
#                 -x xml run
#
# Author        : James Masluk
# Date          : 01/20/05
# Modifications : 12/10/2005 - Added umask 111  (LSJ)
#               : 01/27/2010 - New "pay" cycle type for Assist Rx (sys0123)
#               : 09/27/2012 - New "week" cycle type for Assist Rx (sys0123)
#		: 6/20/2016 - TT15288-48 - Add "tweek" logic. 
 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/programs/obj
LINE_NUM=0000
TEST_MODE=0
SKIP_SORT=0
FILE_FLAG=0
CYCLE="twice"
RERUN_INFO="null"
RERUN=0
TWICE=0
PAY=0
WEEK=0
TWEEK=0
V_5010=0
XML=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmrt01.sh [-c twice,pay,week,hist] [-r <batch range><ccyymmdd>] [-t] [-v] [-x] [-l <line number>] [-f <filename>] 
        -c twice|pay|week|tweek       type of cycle run (required)
        -f filename                to use optional input claims file (optional)
        -r <batchrange><ccyymmdd>  batchrange and end date for rerun (optional)
        -l line numbers            queue numbers for real time processing. ("-l 0000" required for rerun)
        -v version 5010
        -x xml run
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
     "pay")
        PAY=1
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

#
# Submit clmrt01 program
submit_clmrt01()
{
     if [ ${RERUN} = 1 ]
     then
        runcobol ${OBJ_DIR}/clmrt01 -s ${TWEEK}${TWICE}${PAY}${WEEK}${RERUN}${TEST_MODE}${V_5010}${XML} -a ${LINE_NUM}${RERUN_INFO} L=/usr/rmcobol/xmlif.so 
     else
        runcobol ${OBJ_DIR}/clmrt01 -s ${TWEEK}${TWICE}${PAY}${WEEK}${RERUN}${TEST_MODE}${V_5010}${XML} -a ${LINE_NUM} L=/usr/rmcobol/xmlif.so 
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
    -v) V_5010=1
        ;;
    -x) XML=1
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
   CLMRT01KEY=/usr/lnk/wrk/CLMRT01KEY
     export CLMRT01KEY

   OUTDAT0MAS=/usr/lnk/wrk/OUTDAT0TST
     export OUTDAT0MAS

fi

if  [ $PAY = 1 ]
then
        CLMRT01KEY=${CLMRT01KEY}-P
        export CLMRT01KEY
fi
if  [ $TWICE = 1 ]
then
        CLMRT01KEY=${CLMRT01KEY}-T
        export CLMRT01KEY
fi
if  [ $WEEK = 1 ]
then
        CLMRT01KEY=${CLMRT01KEY}-W
        export CLMRT01KEY
fi
if  [ $TWEEK = 1 ]
then
        CLMRT01KEY=${CLMRT01KEY}-X
        export CLMRT01KEY
fi

umask 111

echo "CLMRT01 Data File"
date
submit_clmrt01 
date

exit 0
