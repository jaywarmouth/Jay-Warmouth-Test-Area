#!/bin/ksh
#
# Program Name	: claim72pdmtst.sh
# Description   : Claims to Tape Transfer for warehouse
#                 Command line arguments:
#                 -s Skip sort flag
#                 -r Rerun (batchrange & filename(30-char.) as argument)
#                 -c Type of cycle (pay, twice, day, or week)
#                 -f <filename> Assign alternate CLAIM00MAS file
#		  -z Sample data Flag
# Author	: Mike Paulus
# Date		: 01/31/2008
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TMPIR=/usr/lnk/tmp
SKIP_SORT=0
CYCLE="null"
PAY=0
TWICE=0
RERUN=0
ARGUMENT=""
DAILY=0 
FILE_FLAG=0
SAMP_FLAG=0
WEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim72pdmtst.sh [-s] [-c <day|pay|twice|week>] [-r "batchrange&pathname"] [-f <filename>] [-z]

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
        DAILY=1
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


# Submit claim72pdmtst program
submit_claim72pdmtst()
{
   if [ ${RERUN} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim72pdmtst -s ${SKIP_SORT}${PAY}${TWICE}${DAILY}1${WEEK} -a "${ARGUMENT}"  
     else
        runcobol ${OBJ_DIR}/claim72pdmtst -s ${SKIP_SORT}${PAY}${TWICE}${DAILY}0${WEEK}  
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
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1
        ARGUMENT=$1
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
    -z) SAMP_FLAG=1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign Alternate variables
if [ ${SAMP_FLAG} = 1 ]
then
        ENV_FILE="/usr/lnk/demo/env_var.demo"
        parse_env
fi
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

if  [ $PAY = 1 ]
then
   CLAIM72TSTKEY=${CLAIM72TSTKEY}-P;export CLAIM72TSTKEY
fi
if  [ $DAILY = 1 ]
then
   CLAIM72TSTKEY=${CLAIM72TSTKEY}-D;export CLAIM72TSTKEY
fi
if  [ $TWICE = 1 ]
then
   CLAIM72TSTKEY=${CLAIM72TSTKEY}-T;export CLAIM72TSTKEY
fi
if  [ $WEEK = 1 ]
then
   CLAIM72TSTKEY=${CLAIM72TSTKEY}-W;export CLAIM72TSTKEY
fi

echo "Claims to File for Warehouse - claim72pdmtst"
echo For Redbrick
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLAIM72TSTKEY=$CLAIM72TSTKEY"
date
submit_claim72pdmtst 
date

exit 0
