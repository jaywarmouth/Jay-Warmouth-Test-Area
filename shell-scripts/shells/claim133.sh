#!/bin/ksh
#
# Program Name	: claim133.sh
# Description   : Pharmacy Payment Tapes for PNPS
#                 Command line arguments:
#                 -c Type of cycle (pay or off or twice)
#                 -s Skip sort flag
#                 -f Assign alternate CLAIM00MAS
#		  -r <batch range><ccyymmdd(paid date)> - Rerun
# Author	: Mike Paulus
# Date		: 01/07/2009
# Modifications : 05/18/2009 - Added INLOG logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CYCLE="null"
SKIP_SORT=0
OFF=0
PAY=0
TWICE=0
FILE_FLAG=0
RERUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim133.sh [-c pay|off|twice] [-s] [-f <filename>] [-r <batch range><paid date-ccyymmdd>]

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
     "off")
        OFF=1
        ;;
     "pay")
        PAY=1
        ;;
     "twice")
        TWICE=1
        ;;
    *)  usage
         ;;
   esac
}


# Submit claim133 program
submit_claim133()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
     runcobol ${OBJ_DIR}/claim133 -s ${SKIP_SORT}${OFF}${PAY}${TWICE}${RERUN}  
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
    -r) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	RERUN=1
	RERUN_DATA=$1
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

if [ $PAY = 1 ]
then
	INLOG00MAS=$INLGWRKMAS-P
fi
if [ $TWICE = 1 ]
then
        INLOG00MAS=$INLGWRKMAS-T;export $INLOG00MAS
fi

echo Pharmacy Payment Tapes
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   INLOG00MAS=$INLOG00MAS"

# Submit program
submit_claim133 

date

exit 0
