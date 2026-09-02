#!/bin/ksh
#
# Program Name	: claim72pdmconv.sh
# Description   : Claims to Tape Transfer 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -r Rerun (batchrange & filename(30-char.) as argument)
#                 -c Type of cycle (pay, twice, day, week, tweek)
#                 -f <filename> Assign alternate CLAIM00MAS file
#		  -z Sample data Flag
# Author	: Linda S. Jefferis
# Date		:
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
TWEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim72pdmconv.sh [-s] [-c <day|pay|twice|week|tweek>] [-r "batchrange&pathname"] [-f <filename>] [-z]

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
     "tweek")
        TWEEK=1
        ;;
    *)  usage
         ;;
   esac
}


# Submit claim72pdmconv program
submit_claim72pdmconv()
{
   if [ ${RERUN} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim72pdmconv -s ${SKIP_SORT}${PAY}${TWICE}${DAILY}1${WEEK}${TWEEK} -a "${ARGUMENT}"
     else
        runcobol ${OBJ_DIR}/claim72pdmconv -s ${SKIP_SORT}${PAY}${TWICE}${DAILY}0${WEEK}${TWEEK}
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
   CLAIM72KEY=${CLAIM72KEY}-P;export CLAIM72KEY
fi
if  [ $DAILY = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-D;export CLAIM72KEY
fi
if  [ $TWICE = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-T;export CLAIM72KEY
fi
if  [ $WEEK = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-W;export CLAIM72KEY
fi
if  [ $TWEEK = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-X;export CLAIM72KEY
fi

echo "Claims to Tape Transfer - claim72pdmconv"
echo For Warehouses
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLAIM72KEY=$CLAIM72KEY"
date
submit_claim72pdmconv 
date

exit 0
