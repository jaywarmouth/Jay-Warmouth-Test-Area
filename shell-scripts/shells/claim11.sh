#!/bin/ksh
#
# Program Name	: claim11.sh
# Description   : Claims Summary Report 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c pay|twice
# Author	: Linda S. Jefferis
# Date		: 06/06/96
# Modifications : 04/15/97  Added env_var & OBJ_DIR logic  (LSJ)
#                 04/15/97  Removed proc_audit  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
TWICE=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim11.sh [-s] [-c pay|twice]

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
     "twice")
        TWICE=1
        ;;
     "pay")
	;;
    *)  usage
         ;;
   esac
}

# Submit claim11_newcycle program
submit_claim11()
{
      runcobol ${OBJ_DIR}/claim11 -s ${SKIP_SORT}${TWICE}

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

# Assign alternate environment variables
CLAIM11KEY=${CLAIM11KEY}.m${CYCLE}
export CLAIM11KEY


echo "Claims Summary Report"
echo "    CLAIM11KEY=$CLAIM11KEY"
date
submit_claim11 
date

exit 0
