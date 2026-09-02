#!/bin/ksh
#
# Program Name  : pharm01.sh
# Description   : PHARMACY DEMOGRAPHIC EXTRACTS 
#                 Command Line Arguments:
#                 -o Single network <network - 6-digits>
#                 -t Test Mode
# Author        : D. Tucci
# Date          : 09/06/99
# Modifications : 07/13/2005 - Added umask command  (LSJ)
#		: 07/22/2005 - Addition of "one network" switch
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SING_NET=0
NET="null"
TEST_MODE=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE


usage: pharm01.sh [-o <network>] [-t] 

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


# Submit pharm01 program
submit_pharm01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/pharm01 -s ${SING_NET}${TEST_MODE} -a ${NET}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SING_NET=1
        NET=$1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

umask 002

# Assign alternate environment variables

date

submit_pharm01
date

exit 0
