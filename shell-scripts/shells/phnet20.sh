#!/bin/ksh
#
# Program Name  : phnet20.sh
# Description   : Pharmacy Network Load for PMSI network 408.
# Command Line Arguements:
#                 -t test mode            
#                 -d term mode
#                 -f daily full load
# Author        : Mike Paulus
# Date          : 09/19/07
# Modifications :                                     
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
RPT_DIR=/usr/upd/pharm/pmsi
TEST_MODE=0
TERM_MODE=0
FULL_LOAD=0
AUDIT_DIR="/usr/lnk/audit"
DATE=`date +%m%d`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet20.sh [-t test_mode] [-d term_mode] [-f daily_full_load] 

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


# Submit phnet20 program
submit_phnet20()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet20 -s ${TEST_MODE}${TERM_MODE}${FULL_LOAD}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
    -d) TERM_MODE=1
        ;;
    -f) FULL_LOAD=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ $FULL_LOAD = 1 ]
then
	PHNET20RPT=${PHNET20RPT}-${DATE}; export PHNET20RPT
else
	PHNET20RPT=${HOME}/PHNET20RPT; export PHNET20RPT
fi

FG4AUD=${AUDIT_DIR}/PHAAUD
export FG4AUD

date
submit_phnet20
date

exit 0
