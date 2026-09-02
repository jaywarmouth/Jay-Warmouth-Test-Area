#!/bin/ksh
#
# Program Name	: claim31.sh
# Description   : Key Load for Drug Utilization 
#                 Command line arguments:
#                 -c Type of run (pay or twice)
#                 -s Skip sort flag
#                 -t Alternate run type - claim31a with <16 Char.> Batch range to process
# Author	: Linda S. Jefferis
# Date		: 06/06/96
# Modifications : 04/23/97 Added env_var & OBJ_DIR logic  (LSJ)
#                 04/23/97 Removed proc_audit  (LSJ)
#		  10/05/99 Alternate run type option  (DT)
#                 01/07/05 - Added pay & twice-month cycle (DW)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
CLAIM31A=0
BATCH="null"
CYCLE="null"
PAY=0
TWICE=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim31.sh [-c pay|twice] [-s] [-t <batch range>]

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

# Submit claim31 program
submit_claim31()
{
   if [ ${CLAIM31A} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim31 -s ${SKIP_SORT}${CLAIM31A}${PAY}${TWICE} -a ${BATCH} 
     else
        runcobol ${OBJ_DIR}/claim31 -s ${SKIP_SORT}${CLAIM31A}${PAY}${TWICE} 
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
    -t) CLAIM31A=1
        shift
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

# Parse environment variables
parse_env

#Assign Alternate Variables

  if [ ${CLAIM31A} = 1 ]
  then  
      CLAIM31MAS=${CLAIM31MAS}.31A
      CLAIM31KEY=${CLAIM31KEY}.31A
  else
      CLAIM31MAS=${CLAIM31MAS}.m${CYCLE}
      CLAIM31KEY=${CLAIM31KEY}.m${CYCLE}
  fi

  echo "   CLAIM31MAS=${CLAIM31MAS}"
  echo "   CLAIM31KEY=${CLAIM31KEY}"

echo Key Load for Drug Utilization
date
submit_claim31 
date

exit 0
