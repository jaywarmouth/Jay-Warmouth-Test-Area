#!/bin/ksh
#
# Program Name	: claim72pdm_dbp.sh
# Description   : Claims to Tape Transfer 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -r Rerun (batchrange & filename(30-char.) as argument)
#                 -c Type of cycle (pay, twice, day, week or twiceweek)
#                 -f <filename> Assign alternate CLAIM00MAS file
#		  -z Sample data Flag
# Author	: Linda S. Jefferis
# Date		: 05/03/96
# Modifications : 02/12/97 - Removed proc_audit logic - LSJ
#                 04/22/97 - Added env_var & OBJ_DIR logic - LSJ
#                 01/09/98 - Added Daily flag - CH
#                 01/23/98 - Added -f option  (LSJ)
#		: 05/02/2001 - Added -z flag  (LSJ)
#		: 05/04/2005 - Changes for new week-cycle  (LSJ)
#               : 07/10/2008 - Add twice-week run   (MJP)
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
HOST=`/usr/lnk/shell/get_hostname.sh`
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim72pdm_dbp.sh [-s] [-c <day|pay|twice|week|tweek>] [-r "batchrange&pathname"] [-f <filename>] [-z]

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


# change runcobol line for CIO server use


# Submit claim72pdm_dbp program
submit_claim72pdm_dbp()
{
   if [ ${RERUN} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim72pdm_dbp -s ${SKIP_SORT}${PAY}${TWICE}${DAILY}1${WEEK}${TWICE_WEEK} -a "${ARGUMENT}" L=libdbppp_api.so 
     else
        runcobol ${OBJ_DIR}/claim72pdm_dbp -s ${SKIP_SORT}${PAY}${TWICE}${DAILY}0${WEEK}${TWICE_WEEK} L=libdbppp_api.so 
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

CLAIM72KEY=${CLAIM72KEY}-DBP
export CLAIM72KEY

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

echo "Claims to Tape Transfer - claim72pdm_dbp"
echo For Warehouses
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLAIM72KEY=$CLAIM72KEY"
date

echo  -n ${HOST}"|"${DBP_SERVER_NAME}"|claim72_dbp|"`date +%Y%m%d`"|StartTime|"`date +%H%M%S` > /usr/lnk/wrk/claim72pdm_dbplog

submit_claim72pdm_dbp 

echo  "|"${HOST}"|"${DBP_SERVER_NAME}"|claim72pdm_dbp|"`date +%Y%m%d`"|StopTime|"`date +%H%M%S`"|"    >> /usr/lnk/wrk/claim72pdm_dbplog
cat /usr/lnk/wrk/claim72pdm_dbplog >> /usr/lnk/wrk/CBLDBP_TIME
rm -f /usr/lnk/wrk/claim72pdm_dbplog


date

exit 0
