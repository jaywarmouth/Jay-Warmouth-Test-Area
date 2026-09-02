#!/bin/ksh
#
# Program Name	: claim106.sh
# Description   : Claims Extract for Greg Reardon for Rebates
#                 Command line arguments:
#                 -c Type of cycle (pay|week|mon|twice)  
#                 -b Re-Run with Batch Range and Rerun Date
# Author	: Dave Tucci
# Date		: 11/16/98
# Modifications : 05/03/2005 - Changes for new week cycle  (LSJ)
#		: 09/12/2006 - Addition of mon cycle run  (LSJ)
#               : 09/29/2008 - addition of twice cycle run (MP)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INV="null"
CYCLE="null"
PAY=0
RERUN=0
RERUN_INFO="null"
WEEK=0
MON=0
TWICE=0
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim106.sh [-c pay|week|mon|twice] [-b <batch-range><rerun-date"ccyymmdd">]

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
     "week")
        WEEK=1
        ;; 
     "mon")
        MON=1
        ;;
     "twice")
        TWICE=1
        ;;
    *)  usage
         ;;

   esac
}

# Submit claim106 program
submit_claim106()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/claim106 -s ${PAY}${RERUN}${WEEK}${MON}${TWICE} -a ${RERUN_INFO}  
   fi
}


#
# Main routine
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN_INFO=$1
        RERUN=1
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

#
# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $PAY = 1 ]
then
   CLAIM106KEY=${CLAIM106KEY}-P;export CLAIM106KEY
fi
if [ $WEEK = 1 ]
then
   CLAIM106KEY=${CLAIM106KEY}-W;export CLAIM106KEY
fi
if [ $MON = 1 ]
then
   CLAIM106KEY=${CLAIM106KEY}-M;export CLAIM106KEY
fi
if [ $TWICE = 1 ]
then
   CLAIM106KEY=${CLAIM106KEY}-T;export CLAIM106KEY
fi


echo "Claims Extracts for Pharmaceutical Horizons"
date
echo

# Submit the program
submit_claim106 

date

exit 0
