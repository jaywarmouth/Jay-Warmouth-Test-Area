#!/bin/ksh
#
# Program Name  : ncpdp01.sh
# Description   : NCPDP File Update
# Author        : David Tucci
# Date          : 09/17/97
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
SWITCH_FLAG=0
FULLFILE_FLAG=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ncpdp01.sh [ -s ] [ -f ]

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


# Submit ncpdp01 program
submit_ncpdp01()
{
        if [ ${SWITCH_FLAG} = 1 ]
        then
             if [ ${FULLFILE_FLAG} = 1 ]
             then
                 runcobol ${OBJ_DIR}/ncpdp01 -s 011
             else
                 runcobol ${OBJ_DIR}/ncpdp01 -s 010
             fi
        else
             if [ ${FULLFILE_FLAG} = 1 ]
             then
                 runcobol ${OBJ_DIR}/ncpdp01 -s 001
             else
                 runcobol ${OBJ_DIR}/ncpdp01 -s 000
             fi
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
    -s) SWITCH_FLAG=1
        ;;
    -f) FULLFILE_FLAG=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
NCPTP00TAP=/usr/upd/pharm/NCPTP00TAP
export NCPTP00TAP

echo Alternate & PDM group listing
date
submit_ncpdp01
date

exit 0
