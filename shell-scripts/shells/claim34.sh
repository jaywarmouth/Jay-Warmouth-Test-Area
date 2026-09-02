#!/bin/ksh
#
# Program Name	: claim34.sh
# Description   : Claims Cost Analysis Report 
#                 Command line arguments:
#                 -c Type of run (pay or twice)
#                 -s Skip sort flag
#                 -r Rerun flag with 4-digit system as argument
# Author	: Linda S. Jefferis
# Date		: 06/06/96
# Modifications : 03/12/97 - Added env_var and OBJ_DIR logic - LSJ
#                 03/12/97 - Removed proc_audit logic - LSJ
#		  04/06/99 - Assign special CLAIM34KEY when -r is used  (LSJ)
#		  05/28/99 - Changed -r option to input 4-digit system  (LSJ)
#                 01/07/05 - Added twice-month cycle (DW)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
RERUN=0
SYS="null"
CYCLE="null"
PAY=0
TWICE=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim34.sh [-c pay|twice] [-s] [-r {system#}]

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

# Submit claim34 program
submit_claim34()
{
   if [ ${RERUN} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim34 -s ${SKIP_SORT}${RERUN}${PAY}${TWICE} -a ${SYS}
     else
        runcobol ${OBJ_DIR}/claim34 -s ${SKIP_SORT}${RERUN}${PAY}${TWICE}
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
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYS=$1
        RERUN=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
CARDH80MAS=/usr/upd/crd_01/CARDH80MAS.34
export CARDH80MAS
if [ ${RERUN} = 1 ]
then
    CLAIM34KEY=${CLAIM34KEY}.${SYS}
    export CLAIM34KEY
else
    CLAIM34KEY=${CLAIM34KEY}.m${CYCLE}
    export CLAIM34KEY
fi

echo Claims Cost Analysis Report
date

# Submit the program
submit_claim34 

date

exit 0
