#!/bin/ksh
#
# Program Name	: claim68.sh
# Description   : Invalid Claims Report 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Type of cycle (pay|twice|week|tweek)
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#
#                 01/23/97 - CMS - TOOK OUT EXPORT OF COPAY00MAS=/usr/pdm/claims/COPAY00NEW
#                 03/21/97 - Added env_var & OBJ_DIR logic - LSJ
#                 03/21/97 - Removed proc_audit - LSJ
#                 06/25/97 - Changed directory and filename for PRINT-7 - LSJ
#                 12/03/04 - Add in new switches for new billing cycle - CMH
#		  05/04/2005 - Changes for new week-cycle  (LSJ)
#                 09/17/2010 - Changes for new tweek-cycle (MJP)
#		  10/14/2016 - change of switches to linkage arguments in runcobol statement.
#		  12/06/2016 - TT16324-3

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
PRT_DIR=/usr/lnk/misc
PAY=0
TWICE=0
WEEK=0
TWEEK=0
DISP_ERROR=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim68.sh [-s] [-c pay|twice|week|tweek]

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


# Submit claim68 program
submit_claim68()
{
   if [ ${CYCLE} = "null" ]
   then
      usage
   else
      runcobol ${OBJ_DIR}/claim68 -a ${SKIP_SORT}${PAY}${TWICE}${WEEK}${TWEEK}
	RETVAL=$?
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate variables
if [ $PAY = 1 ]
then 
   CLAIM68KEY=${CLAIM68KEY}-P;export CLAIM68KEY
fi
if [ $TWICE = 1 ]
then 
   CLAIM68KEY=${CLAIM68KEY}-T;export CLAIM68KEY
fi
if [ $WEEK = 1 ]
then
   CLAIM68KEY=${CLAIM68KEY}-W;export CLAIM68KEY
fi
if [ $TWEEK = 1 ]
then
   CLAIM68KEY=${CLAIM68KEY}-X;export CLAIM68KEY
fi


echo "Invalid Claims Report"

date
echo "EXPORT PATHS:"
echo "    CLAIM68KEY=$CLAIM68KEY"
echo "	  CLAIM00MAS=$CLAIM00MAS"
echo "    SYSTE00MAS=$SYSTE00MAS"
submit_claim68 
date
echo "RETVAL=$RETVAL"

exit $RETVAL
