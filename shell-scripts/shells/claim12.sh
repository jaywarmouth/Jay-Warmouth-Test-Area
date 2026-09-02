#!/bin/ksh
#
# Program Name	: claim12.sh
# Description   : Unauthorized Claims Report 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Type of cycle (pay|twice|week)
#                 -f Assign alternate CLAIM00MAS
#                 -t Alternate run type - claim12a with <16 Char.> Batch range to process
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#               : 02/12/97 - Removed proc_audit logic - LSJ
#                 03/12/97 - Added env_var & OBJ_DIR logic - LSJ
#                 03/12/97 - Added -f option
#		  10/08/99 - Added alternate run type option  (DT)
#		: 05/03/2005 - Changes for new week-cycle  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
SKIP_SORT=0
CLAIM12A=0
BATCH="null"
PAY=0
TWICE=0
WEEK=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim12.sh [-s] [-c pay|twice|week] [-f <filename>] [-t <batch range>]

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
    *)  usage
         ;;
   esac
}


# Submit claim12 program
submit_claim12()
{

   if [ ${CLAIM12A} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim12 -s ${SKIP_SORT}${PAY}${TWICE}${CLAIM12A}${WEEK} -a ${BATCH}
     else
        runcobol ${OBJ_DIR}/claim12 -s ${SKIP_SORT}${PAY}${TWICE}${CLAIM12A}${WEEK}  
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;

    -t) shift
	CLAIM12A=1
        if [ $# -le 0 ]
        then
          usage
        else
          BATCH=$1
        fi
        ;;
  esac
  shift
done

#Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

if [ ${CLAIM12A} = 1 ]
then
   CLAIM12KEY=${CLAIM12KEY}.12A
fi
if [ $PAY = 1 ]
then
   CLAIM12KEY=${CLAIM12KEY}-P;export CLAIM12KEY
fi
if [ $TWICE = 1 ]
then
   CLAIM12KEY=${CLAIM12KEY}-T;export CLAIM12KEY
fi
if [ $WEEK = 1 ]
then
   CLAIM12KEY=${CLAIM12KEY}-W;export CLAIM12KEY
fi

echo Unauthorized Claims Report
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"

# Submit the program
submit_claim12 

date

exit 0
