#!/bin/ksh
#
# Program Name	: rentnet02.sh
# Description   : Claim Invoice Detail 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -t System Level 
#                 -x Sponsor Level
#                 -c Cycle 
#                 -r <batch range><rerun date-ccyymmdd>
#                     rerun date is period ending date
# Author	: James Masluk
# Date		: 
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
SYSTEM_LEVEL=0
SPONSOR_LEVEL=0
PAY=0
TWICE=0
RERUN_INFO="null"
RERUN=0
WEEK=0
TWEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rentnet02.sh [-s] [-t system_level] [-x sponsor_level] [-c pay|twice|week|tweek] [-r <batch range><ccyymmdd>]
	-c pay|twice|week|tweek
        -s skip sort flag (optional)
  (Note: Only one of the following two flags should be set at one time-not both)
        -t system level
        -x sponsor level
        -r rerun - <batchrange><ccyymmdd>  batchrange and end date for rerun (optional)


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


# Submit rentnet02 program
submit_rentnet02()
{
    runcobol ${OBJ_DIR}/rentnet02 -s ${SKIP_SORT}${SYSTEM_LEVEL}${SPONSOR_LEVEL}${PAY}${TWICE}${RERUN}${WEEK}${TWEEK} -a ${RERUN_INFO}
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
    -t) SYSTEM_LEVEL=1
        ;;
    -x) SPONSOR_LEVEL=1
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
        RERUN=1
        RERUN_INFO=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign other variables
if [ $PAY = 1 ]
then
   RENTN00MAS=${RENTN00WRK}-P
   RENTN02KEY=${RENTN02KEY}-P
fi
if [ $TWICE = 1 ]
then
   RENTN00MAS=${RENTN00WRK}-T
   RENTN02KEY=${RENTN02KEY}-T
fi
if [ $WEEK = 1 ]
then
   RENTN00MAS=${RENTN00WRK}-W
   RENTN02KEY=${RENTN02KEY}-W
fi
if [ $TWEEK = 1 ]
then
   RENTN00MAS=${RENTN00WRK}-X
   RENTN02KEY=${RENTN02KEY}-X
fi
export RENTN00MAS RENTN02KEY


echo "Rented Network Detail Report"
echo "   RENTN00MAS=$RENTN00MAS"
echo "	 RENTN02KEY=$RENTN02KEY"

date
submit_rentnet02 
date

exit 0
