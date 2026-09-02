#!/bin/ksh
#
# Program Name	: claim46.sh
# Description   : Select Reversals 
#                 Command line arguments:
#                 -c Type of cycle (pay, twice, week, tweek)
#                 -s Skip sort flag
#                 -d Set alternate start date <ccyymmdd>
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#                 03/19/97 - Added env_var & OBJ_DIR logic - LSJ
#                 03/19/97 - Removed proc_audit - LSJ
#                 06/13/97 - Added -d command line argument - LSJ
#		  11/25/98 - Changed assignment of AUDIT20MAS  (LSJ)
#		  05/28/99 - Added century to input date  (LSJ)
#		  11/11/04 - Added Type of cycle (pay or twice-month) (DW)
#                 04/06/05 - Added (week) cycle (DW)
#                 09/20/10 - Added (tweek) cycle MJP
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
CYCLE="null"
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
DATE_FLAG=0
PAY=0
TWICE=0
WEEK=0
TWEEK=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim46.sh  [-c pay|twice|week|tweek] [-s] [-d <ccyymmdd>]
        -c <pay|twice|week|tweek>                   required
        -s          Skip Sort Flag                  optional
        -d          Input date                      optional


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

# Submit claim46 program
submit_claim46()
{
   if [ ${CYCLE} = "null" ] 
   then
     usage
   else
     if [ ${DATE_FLAG} = 1 ]
     then
       runcobol ${OBJ_DIR}/claim46 -s ${SKIP_SORT}1${PAY}${TWICE}${WEEK}${TWEEK} -a ${DATE}
     else
       runcobol ${OBJ_DIR}/claim46 -s ${SKIP_SORT}0${PAY}${TWICE}${WEEK}${TWEEK}
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
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE_FLAG=1
        DATE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

AUDIT20MAS=/usr/lnk/audit/CLAIM02
export AUDIT20MAS

if [ $PAY = 1 ]
then
   CLAIM46KEY=${CLAIM46KEY}-P;export CLAIM46KEY
fi
if [ $TWICE = 1 ]
then 
   CLAIM46KEY=${CLAIM46KEY}-T;export CLAIM46KEY
fi
if [ $WEEK = 1 ]
then
   CLAIM46KEY=${CLAIM46KEY}-W;export CLAIM46KEY
fi
if [ $TWEEK = 1 ]
then
   CLAIM46KEY=${CLAIM46KEY}-X;export CLAIM46KEY
fi


echo Select Reversals
date
echo "EXPORT PATHS:"
echo "   CLAIM46KEY=$CLAIM46KEY"
submit_claim46 
date

exit 0
