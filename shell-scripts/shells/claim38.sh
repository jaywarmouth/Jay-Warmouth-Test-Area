#!/bin/ksh
#
# Program Name	: claim38_newcycle.sh
# Description   : Physician Utilization Report 
#                 Command line arguments:
#                 -l Level of report (sys,spo,grp,sub)
#                 -s Skip sort flag
#                 -c <pay|twice>
# Author	: Linda S. Jefferis
# Date		: 06/21/96
# Modifications : 04/23/97 Added env_var & OBJ_DIR logic  (LSJ)
#                 04/23/97 Removed proc_audit  (LSJ)
#		: 03/28/2005 Addition of <pay|twice> logic
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
KEY_DIR=/usr/lnk/keys
LEVEL="null"
SKIP_SORT=0
TWICE=0
SYS=0
SPO=0
GRP=0
SUB=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim38.sh [-l sys|spo|grp|sub] [-s] [-c pay|twice]

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
# Validate -l options
validate_level()
{  case ${LEVEL} in
     "sys")
        SYS=1
         ;;
     "spo")
        SPO=1
         ;;
      "grp")
        GRP=1
         ;;
      "sub")
        SUB=1
         ;;
     *)  usage
	 ;;
   esac
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


# Submit claim38_newcycle program
submit_claim38()
{
       runcobol ${OBJ_DIR}/claim38 -s ${SYS}${SPO}${GRP}${SUB}${SKIP_SORT}${TWICE}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -l) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        LEVEL=$1
        validate_level
        ;;
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
CLAIM38KEY=${CLAIM38KEY}.m${CYCLE}${LEVEL}
export CLAIM38KEY

echo "Physician Utilization Report"
echo "    CLAIM38KEY=${CLAIM38KEY}"
date
submit_claim38 
date

exit 0
