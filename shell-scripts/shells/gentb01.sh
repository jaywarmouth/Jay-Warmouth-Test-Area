#!/bin/ksh
#
# Program Name  : gentb01.sh
# Description   : Create Generic Table File For RXEOB
#                 Command line arguments:
#                   -a System Link (ex.- PRM, AMS, SUMA, ect.)
# Author        : James Masluk
# Date          : 09/18/01
#		: 12/29/2008 - Added display of SYSLINK to output  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SYSLINK=" "
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gentb01.sh -a ["system link"]

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


# Submit gentb01 program
submit_gentb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/gentb01 -a ${SYSLINK}'     ' 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) shift
        if [ $# -le 0 ]
        then
           usage
        fi
        SYSLINK=$1
        ;;
   esac
   shift
done

# Parse environment variables
parse_env

umask 002

# Assign alternate environment variables

date

echo ""
echo "SYSLINK=$SYSLINK"

submit_gentb01
date

exit 0
