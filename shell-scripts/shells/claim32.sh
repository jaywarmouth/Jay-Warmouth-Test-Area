#!/bin/ksh
#
# Program Name	: claim32.sh
# Description   : Drug Utilization Report 
#                 Command line arguments:
#                 -c Type of run (pay or twice)
#                 -s Skip sort flag
# Author	: Linda S. Jefferis
# Date		: 06/06/96
# Modifications : 04/23/97 Added env_var & OBJ_DIR logic  (LSJ)
#                 04/23/97 Remove proc_audit  (LSJ)
#		: 03/31/2005 Addition of pay|twice selections
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
CYCLE="null"
PAY=0
TWICE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim32.sh [-s] [-c pay|twice]

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
    *)  usage
         ;;
   esac
}



# Submit claim32 program
submit_claim32()
{
   runcobol ${OBJ_DIR}/claim32 -s ${SKIP_SORT}${PAY}${TWICE}
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign Alternate Variables
CLAIM31MAS=${CLAIM31MAS}.m${CYCLE}
CLAIM32KEY=${CLAIM31KEY}.m${CYCLE}

echo Drug Utilization Report
date
submit_claim32 
date

exit 0
