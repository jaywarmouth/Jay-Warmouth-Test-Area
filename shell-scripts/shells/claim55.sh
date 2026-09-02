#!/bin/ksh
#
# Program Name	: claim55.sh
# Description   : Incurred Claims Update of CLAIM55MAS 
#                 Command line arguments:
#                 -c Type of run (pay|twice|week|tweek)
#                 -m Load-Month-option flag
#                 -y Load-Year-option flag
#                 -s Skip sort flag
#                 -f Assign Alternate CLAIM55MAS 
# Author	: Linda S. Jefferis
# Date		: 08/23/96
# Modifications : 03/28/97 - Added env_var & OBJ_DIR logic
#                 03/28/97 - Removed proc_audit
#                 12/03/04 - Added twice-month cycle (DW)
#                 12/03/04 - Deleted re-run cycle    (DW)
#		  07/06/2005 - Changed runcobol  (LSJ)
#		  07/06/2005 - Additions for week-cycle  (LSJ)
#		  12/14/2009 - Replaced MON with MEDD week-cycle
#		  01/08/2010 - Changed CLAIM55 file name for MEDD
#		  06/08/2010 - Changed logic for assigning CLAIM55MAS and CLAIM55KEY variables.
#		  11/02/2010 - Changes for new tweek cycle  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CYCLE="null"
SKIP_SORT=0
RERUN=0
LOAD_MON=0
LOAD_YR=0
CLEAR_MON=0
ARGUMENT=""
FILE_FLAG=0
PAY=0
TWICE=0
WEEK=0
TWEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim55.sh [-c pay|twice|week|tweek] [-m] [-y] [-s] [-f <filename>]

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
	CYC_LET="P"
	;;
     "twice")
	TWICE=1
	CYC_LET="T"
	;;
     "week")
	WEEK=1
	CYC_LET="W"
	;;
     "tweek")
	TWEEK=1
	CYC_LET="X"
	;;
     *)  usage
	 ;;
   esac
}

# Submit claim55 program
submit_claim55()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
     runcobol ${OBJ_DIR}/claim55 -s ${LOAD_MON}${LOAD_YR}${CLEAR_MON}${SKIP_SORT}${TWEEK}${PAY}${TWICE}${WEEK} 
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
    -m) LOAD_MON=1
        CLEAR_MON=1
        ;;
    -y) LOAD_YR=1
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${FILE_FLAG} = 1 ]
then
	CLAIM55MAS=${FILE}
else
	CLAIM55MAS=${CLAIM55MAS}.${CYCLE}
	CLAIM55KEY=$CLAIM55KEY-${CYC_LET}
fi
export CLAIM55MAS CLAIM55KEY


echo Incurred Claims Update of CLAIM55MAS
date
echo "EXPORT PATHS:"
echo "   CLAIM55MAS=$CLAIM55MAS"
echo "   CLAIM55KEY=$CLAIM55KEY"
submit_claim55 
date

exit 0
