#!/bin/ksh
#
# Program Name	: clncpdp01.sh
# Description   : NCPDP Post Adjudication data feed to Fred's 
#                 Command line arguments:
#                 -c Type of cycle (pay)
#                 -s Skip sort flag
#                 -r Re-Run with Batch Range and Rerun Date (CCYYMMDD)
#			for pay-cycle - rerun date is period end date
# Author	: Michael Paulus   
# Date		: 05/26/2010
# Modifications :
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
RERUN=0
RERUN_INFO="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clncpdp01.sh [-c pay] [-s]  [-r <batch-range><rerun-date"ccyymmdd">]

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

# Assign Alternate environment variables
alt_env()
{
   if [ ${CYCLE} = "null" ]
   then
      usage
   else
      case ${CYCLE} in
        "pay")
           CLNCPDP01KEY=${CLNCPDP01KEY}-P;export CLNCPDP01KEY
           ;;
      esac
   fi
}
          
# Submit clncpdp01 program
submit_clncpdp01()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/clncpdp01 -s ${SKIP_SORT}${PAY}${RERUN} -a ${RERUN_INFO}
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
    -r) shift
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
    -s) SKIP_SORT=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
alt_env


echo "Claims Data File - clncpdp01"
date
submit_clncpdp01 
date

exit 0
