#!/bin/ksh
#
# Program Name	: claim19.sh
# Description   : Cardholder Audit and Drug Utilization Review
#                 Command line arguments:
#                 -n Print No Name on Audit
#                 -l Limit11 Flag
#                 -q Quarterly Report
#                 -a Audit Report Only 
#                 -f Flexgen Run
#                 -d Audit and Drug Util Report
#		  -z Demo run
#                 -i Differential amounts added in.
# Author	: Christina M. Senediak
# Date		: 06/24/96
# Modifications : 06/25/96 - Added path change for CLAIM19MAS for quarter run. 
#                 06/18/97 LSJ  Added env_var & OBJ_DIR logic
#                 09/26/97 CMH - Added logic for Flexgen run of shell.
#                 05/27/98 CMH - Added logic for Limit11 flag run.
#		  11/11/99 LSJ - Added demo run logic.
#                 02/04/02 CMH - Add logic in for Differential switch.
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PO_MISC=/usr/lnk/misc
NO_NAME=0
LIMIT11_FLAG=0
QUARTER=0
AUDIT=0
USERCLASS=""
USER=""
FLEX=0
DEMO=0
DIFF=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim19.sh [-n] [-l <userclass> <user>] [-q <userclass> <user>] [-a] [-f] [-d] [-z] [-i]

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit claim19 program
submit_claim19()
{
          if [ ${QUARTER} = 0 ]
           then
             if [ ${FLEX} = 1 ]
              then
                CLAIM19MAS=$HOME/CLA19${USER};export CLAIM19MAS
                runcobol ${OBJ_DIR}/claim19 -s 000${NO_NAME}0${DIFF}0${AUDIT} -a ${USERCLASS}${USER}'           '
              else
                if [ ${LIMIT11_FLAG} = 1 ]
                 then
                   CLAIM19MAS=$PO_MISC/CLAIM19_LI11;export CLAIM19MAS
                   echo $CLAIM19MAS
                   runcobol ${OBJ_DIR}/claim19 -s 000${NO_NAME}1${DIFF}0${AUDIT} -a ${USERCLASS}${USER}'            '
                 else
                   runcobol ${OBJ_DIR}/claim19 -s 10000000 -a ${USERCLASS}${USER}'           '
                   runcobol ${OBJ_DIR}/claim19 -s 000${NO_NAME}0${DIFF}0${AUDIT} -a ${USERCLASS}${USER}'            '
                fi
             fi
           else
             echo Quarter Cycle:
             CLAIM19MAS=/usr/upd/claims/CLAIM19MAS.qua;export CLAIM19MAS
             runcobol ${OBJ_DIR}/claim19 -s 00000010 -a ${USERCLASS}${USER}'            '
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
    -n) NO_NAME=1   
        AUDIT=1
        FLEX=1
        USERCLASS=$2
        USER=$3
        ;;
    -l) LIMIT11_FLAG=1
        AUDIT=1
        USERCLASS=$2
        USER=$3
        cp $PO_MISC/???LI11 $PO_MISC/CLAIM19_LI11
        ;;
    -q) QUARTER=1
        USERCLASS=$2
        USER=$3
        ;;
    -a) AUDIT=1
        USERCLASS=$2
        USER=$3
        ;;
    -f) AUDIT=1
        USERCLASS=$2
        USER=$3
        FLEX=1
        ;;
    -d) USERCLASS=$2
        USER=$3
        FLEX=1
        ;;
    -z) DEMO=1
	;;
    -i) DIFF=1
        AUDIT=1
        FLEX=1
        USERCLASS=$2
        USER=$3
        ;;
  esac
  shift
done

#Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${DEMO} = 1 ]
then
   ENV_FILE=/usr/lnk/demo/env_var.demo
   parse_env
fi

echo Cardholder Audit and Drug Utilization
date
submit_claim19 
date

exit 0
