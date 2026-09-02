#!/bin/ksh
#
# Program Name	: claim08.sh
# Description   : Check Register Report for Ultimed System 51
#                 Command line arguments:
#                 -c Type of cycle (pay)
#                 -s Skip sort flag
#                 -r Rerun flag
#                 -n Negative check flag
#                 -f Assign alternate CLAIM00MAS
# Author	: Linda S. Jefferis
# Date		: 04/28/2000
# Modifications : 02/07/2002 - Added logic to cp the electronic file to the uhmo home transfer directory  (LSJ)
#		: 03/05/2002 - Removed logic for the electronic file  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CYCLE="null"
SKIP_SORT=0
PAY=0
TWICE=0
OFF=0
RERUN=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim08.sh [-c pay] [-s] [-r] [-n] [-f <filename>]

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
    *)  usage
         ;;
   esac
}


# Submit claim08 program
submit_claim08()
{
   if [ ${CYCLE} = "null" ]
   then
      usage 
   else
      runcobol ${OBJ_DIR}/claim08 -s ${SKIP_SORT}${PAY}${RERUN}${NEG_CHK}
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
    -r) RERUN=1
        ;;
    -n) NEG_CHK=1
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
if  [ $PAY = 1 ]
then
   CHECK00MAS=/usr/upd/claims/CHKWRK-P;export CHECK00MAS
   INLGWRKMAS=${INLGWRKMAS}-P;export INLGWRKMAS
fi
if [ $TWICE = 1 ]
then
   CHECK00MAS=/usr/upd/claims/CHKWRK-T;export CHECK00MAS
   INLGWRKMAS=${INLGWRKMAS}-T;export INLGWRKMAS
fi
if  [ $OFF = 1 ]
then
   CHECK00MAS=/usr/upd/claims/CHKWRK-O;export CHECK00MAS
   INLGWRKMAS=${INLGWRKMAS}-O;export INLGWRKMAS
fi

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

echo Special Resorted Check Register Report-only
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CHECK00MAS=$CHECK00MAS"
echo "   INLGWRKMAS=$INLGWRKMAS"
submit_claim08 
date

exit 0
