#!/bin/ksh
#
# Program Name  : status01.sh
#               Command line arguments:
#               -b Input Batch Range
# Description   : Redbrick STATUS File Extract
# Author        : Dave Tucci
# Date          : 06/26/98
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/po/misc
USER=""
ARG_DATES="null"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: status01.sh [-b <batchrange> ]

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


# Submit status01 program
submit_status01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/status01 -a ${ARG_DATES}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ARG_DATES=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_status01
date

exit 0
