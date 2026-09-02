#!/bin/ksh
#
# Program Name	: claim13_newcycle.sh
# Description   : Pharmacy Utilization Report 
#                 Command line arguments:
#                 -f Assign alternate CLAIM00MAS for CLAIM13A Run
#                 -l Level of report (sys,spo,grp,sub)
#                 -s Skip sort flag
#                 -c <pay|twice>
# Author	: Linda S. Jefferis
# Date		: 06/21/96
# Modifications : 04/23/97 Added env_var & OBJ_DIR logic  (LSJ)
#                 04/23/97 Removed proc_audit  (LSJ)
#		  10/08/99 Added option logic for claim13a run  (DT)
#		: 03/28/2005 Added newcycle (pay|twice) options
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
CLAIM13A=0
TWICE=0
SYS=0
SPO=0
GRP=0
SUB=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim13.sh [-f <filename>] [-l sys|spo|grp|sub] [-s] [-c pay|twice]

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

# Submit claim13_newcycle program
submit_claim13()
{
            
       runcobol ${OBJ_DIR}/claim13 -s ${SYS}${SPO}${GRP}${SUB}${SKIP_SORT}${TWICE}${CLAIM13A}
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        claim13A=1
        FILE=$1
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

if [ ${CLAIM13A} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
   echo " CLAIM00MAS=$CLAIM00MAS"

fi
CLAIM13KEY=${CLAIM13KEY}.m${CYCLE}${LEVEL}
export CLAIM13KEY


echo "Pharmacy Utilization Report"
echo "    CLAIM13KEY=${CLAIM13KEY}"
date
submit_claim13 
date

exit 0
