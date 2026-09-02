#!/bin/ksh
#
# Program Name	: claim09.sh
# Description   : Claims Itemization Report 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Type of cycle (pay|twice|week)
#		  -t <4-digit sys #> - Select system run type
#		  -r Rerun - reports on entire assigned CLAIM00MAS; ignores date and batch checks with SYSTE00MAS file. Replaced claim09_weekcyclea.
#                 -f Assign alternate CLAIM00MAS
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#               : 02/12/97 - Removed proc_audit logic - LSJ
#               : 03/10/97 - Added -f command line argument - LSJ
#               : 03/10/97 - Added env_var and OBJ_DIR logic - LSJ
#               : 03/10/97 - Removed proc_audit - LSJ
#               : 05/30/97 - Added -r command line argument - LSJ
#		: 05/29/99 - option -r must now be 4-digits  (LSJ)
#		: 10/04/99 - Changed previous -r option to a -t option  (LSJ)
#		: 10/04/99 - Added a new rerun option that replaces claim09_weekcyclea  (LSJ)
#		: 12/03/04 - Changes for newcycle runs  (LSJ)
#		: 05/02/2005 - Changes for new week-cycle  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
RERUN=0
SEL_SYS=0
FILE_FLAG=0
ARGUMENT="null"
PAY=0
TWICE=0
WEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim09.sh [-s] [-c pay|twice|week] [-t <system#>] [-r] [-f <filename>]

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

# Submit claim09 program
submit_claim09()
{
   if [ ${SEL_SYS} = 1 ]
     then
        if [ ${CYCLE} = "null" ]
        then
           usage
        else
           runcobol ${OBJ_DIR}/claim09 -s ${SKIP_SORT}${PAY}${TWICE}${SEL_SYS}${RERUN}${WEEK} -a ${ARGUMENT}
        fi
     else
        if [ ${CYCLE} = "null" ]
        then
           usage
        else
           runcobol ${OBJ_DIR}/claim09 -s ${SKIP_SORT}${PAY}${TWICE}${SEL_SYS}${RERUN}${WEEK}
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
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ARGUMENT=$1
        SEL_SYS=1
        ;;
    -r) RERUN=1
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
   CLAIM09KEY=${CLAIM09KEY}-P;export CLAIM09KEY
fi
if  [ $TWICE = 1 ]
then
   CLAIM09KEY=${CLAIM09KEY}-T;export CLAIM09KEY
fi
if  [ $WEEK = 1 ]
then
   CLAIM09KEY=${CLAIM09KEY}-W;export CLAIM09KEY
fi

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi


echo Claims Itemization Report
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"

#Submit the program
submit_claim09 

date

exit 0
