#!/bin/ksh
#
# Program Name	: claim113.sh
# Description   : Claims Files for Aultman
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Type of Cycle(week, tweek)
#		  -r <batch range - period end date>
# Author	: Dave Tucci
# Date		: 06/14/99
# Modifications : 11/12/2000 - Changed displayed heading on  (LSJ)
#                 05/15/2001 - Added Week Cycle (JM)
#                 10/06/2010 - Changes for tweek cycle addition (MJP)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
RERUN=0
RERUN_INFO="null"
WEEK=0
TWEEK=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim113.sh [-s] [-c week|tweek] [-r <batch-range><rerun-date"ccyymmdd">]

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

# Assign Alternate environment variables
alt_env()
{
   if [ ${CYCLE} = "null" ]
   then
      usage
   else
      case ${CYCLE} in
        "week")
           CLAIM113KEY=${CLAIM113KEY}-W;export CLAIM113KEY
           ;;
        "tweek")
           CLAIM113KEY=${CLAIM113KEY}-X;export CLAIM113KEY
      esac
   fi
}


# Submit claim113 program
submit_claim113()
{
    if [ ${RERUN} = 1 ]
    then
      runcobol ${OBJ_DIR}/claim113 -s ${SKIP_SORT}${WEEK}${TWEEK}${RERUN} -a ${RERUN_INFO}
    else
      runcobol ${OBJ_DIR}/claim113 -s ${SKIP_SORT}${WEEK}${TWEEK}${RERUN}
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
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN_INFO=$1
        RERUN=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Claims to File Transfer - claim113"
echo "Aultcare"
echo "CLAIM00MAS=$CLAIM00MAS"
echo "SYSTE00MAS=$SYSTE00MAS"
date
submit_claim113 
date

exit 0
