#!/bin/ksh
#
# Program Name  : pharm04.sh
# Description   : Pharmacy Network Dispensing Fee Report
#		  Command Line Arguments:
#                 -s Skip sort flag
#                 -t <System Number - 4-digits>
#                 -r <ccyymmdd> - Rerun option
#                 -z Test Mode (Demo)
# Author        : James Masluk
# Date          : 02/05/04
# Modifications : 05/05/05 - Rerun Switch (jm)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj 
SKIP_SORT=0
SYS=0000
TEST_MODE=0
RERUN=0
DATE=00000000

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pharm04.sh [-s] [-z] [-t <#### - sys#>] [-r <ccyymmdd>]

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


# Submit pharm04 program
submit_pharm04()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/pharm04 -s ${SKIP_SORT}${TEST_MODE}${RERUN} -a ${SYS}${DATE}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -z) TEST_MODE=1
        ;;
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYS=$1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1
        DATE=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

umask 002

# Assign alternate environment variables

if [ ${TEST_MODE} = 1 ]
then

   PHARM04KEY=/usr/lnk/wrk/PHARM04KEY
     export PHARM04KEY  
fi


echo "Network Dispensing Fee Report"
date
submit_pharm04
date

exit 0
