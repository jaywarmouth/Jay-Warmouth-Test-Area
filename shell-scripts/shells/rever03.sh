#!/bin/ksh
#
# Program Name  : rever03.sh
# Description   : Update Reversal State Codes
#                 Command line arguments:
#                 -s Skip sort flag
#                 -d Set alternate start date <ccyymmdd>
#                 -c Type of cycle (pay,twice-month,week, tweek )
# Author        : Debbie Wilson
# Date          : 11/03/98
# Modifications : 11/25/98 - Added assignment of AUDIT20MAS variable
#		  12/11/98 - Changed AUDIT20MAS to FG4AUD (=REVAUD)
#		  05/27/99 - changed input date to 8-digits 
#		: 05/05/2005 - Changes for new week-cycle  (LSJ)
#		: 04/17/2007 - Fixed /usr/lnk/wrk/REVAUD to /usr/lnk/audit/REVAUD  (LSJ)
#               : 09/28/2010 - Add tweek cycle.
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
PAY=0
TWICE=0
CYCLE="null"
WEEK=0
TWEEK=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rever03.sh [-s] [-d <ccyymmdd>] [-c pay|twice|week|tweek]

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

# Submit rever03 program
submit_rever03()
{
   runcobol ${OBJ_DIR}/rever03 -s ${SKIP_SORT}${DATE_FLAG}${PAY}${TWICE}${WEEK}${TWEEK} -a ${DATE}
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

FG4AUD=/usr/lnk/audit/REVAUD
  export FG4AUD

if  [ $PAY = 1 ]
then
   REVER03KEY=${REVER03KEY}-P;export REVER03KEY
fi
if  [ $TWICE = 1 ]
then
   REVER03KEY=${REVER03KEY}-T;export REVER03KEY
fi
if  [ $WEEK = 1 ]
then
   REVER03KEY=${REVER03KEY}-W;export REVER03KEY
fi
if  [ $TWEEK = 1 ]
then 
   REVER03KEY=${REVER03KEY}-X;export REVER03KEY
fi

echo "Update Reversal State Codes"
date
submit_rever03
date

exit 0

