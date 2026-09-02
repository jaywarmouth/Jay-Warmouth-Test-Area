#!/bin/ksh
#
# Program Name  : rttrl01.sh
# Description   : REAL TIME TRAILER RECORD
#		  Command Line Arguments:
#                 -t Test Mode
#		  -c <client id>
#		  -d <ccyymmdd> - use for a rerun of file other than previous day's file
# Author        : Jim Masluk
# Date          : 02/11/2012
# Modifications : 03/21/2012 - LSJ
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TEST_MODE=0
CLIENT="null"
DATE="00000000"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rttrl01.sh  [-t] -c [client] -d [date] 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file...                                                 "

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


# Submit rttrl01 program
submit_rttrl01()
{
    echo ${DATE}
    runcobol ${OBJ_DIR}/rttrl01 -s ${TEST_MODE} -a ${CLIENT}${DATE} 

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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLIENT=$1
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ $CLIENT = "null" ]
then
	usage
fi

echo "ADD TRAILER RECORD"
date
submit_rttrl01
date

exit 0
