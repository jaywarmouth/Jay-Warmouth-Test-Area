#!/bin/ksh
#
# Program Name  : cardh73.sh
# Description   : Hospice Pharmacy Solutions Automated Eligibility Process
#		  Command Line Arguments:
#                 -l Line Number
#                 -t Test Mode (Demo)
#
# Author        : James Masluk
# Date          : 06/18/04
# Modifications : 12/10/2005 - Added umask 111  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FG4AUD_DIR="/usr/lnk/audit"
AUDNAME="CRDAUD-RT"
LINE_NUM=00
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh73.sh [-t] [-l <line number>]

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


# Submit cardh73 program
submit_cardh73()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/cardh73 -s ${TEST_MODE} -a ${LINE_NUM}

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
    -l) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        LINE_NUM=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

   FG4AUD=${FG4AUD_DIR}/${AUDNAME}
   export FG4AUD


# Assign alternate environment variables

umask 111
 
echo "Hospice Pharmacy Solutions Automated Eligibility"
date
submit_cardh73 
date

exit 0
