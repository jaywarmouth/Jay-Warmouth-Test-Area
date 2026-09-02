#!/bin/ksh
#
# Program Name  : elgrt02.sh
# Description   : Automated Eligibility Program
#		  Command Line Arguments:
#                 -l Line Number
#                 -t Test Mode (Demo)
#		  -b Backup switch
#
# Author        : James Masluk
# Date          : 01/05/05
# Modifications : 08/30/05 - Changed FG4AUD assignment  (LSJ)
#		: 12/10/2005 - Added umask 111  (LSJ)
#		: 08/16/2011 - Add -b option
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
LINE_NUM=00
TEST_MODE=0
BACKUP=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elgrt02.sh [-t] [-l <line number>]

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


# Submit elgrt02 program
submit_elgrt02()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/elgrt02 -s ${TEST_MODE}${BACKUP} -a ${LINE_NUM} 

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
    -b) BACKUP=1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

FG4AUD=/usr/lnk/audit/CRDAUD-RT
export FG4AUD

umask 111
 
echo "Trial Card Automated Eligibility Program"
date
submit_elgrt02 
date

exit 0
