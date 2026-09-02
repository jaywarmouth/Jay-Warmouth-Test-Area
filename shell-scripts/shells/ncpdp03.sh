#!/bin/ksh
#
# Program Name  : ncpdp03.sh
# Description   : NCPDP File Update
# Author        : Christina Harris
# Date          : 11/20/97
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
REPORT_ONLY=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ncpdp03.sh [ -r ] [ -s ] [ -f ]

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


# Submit ncpdp03 program
submit_ncpdp03()
{
        if [ ${SWITCH_FLAG} = 1 ]
        then
             if [ ${FULLFILE_FLAG} = 1 ]
             then
                 runcobol ${OBJ_DIR}/ncpdp03 -s ${REPORT_ONLY}11
             else
                 runcobol ${OBJ_DIR}/ncpdp03 -s ${REPORT_ONLY}10
             fi
        else
             if [ ${FULLFILE_FLAG} = 1 ]
             then
                 runcobol ${OBJ_DIR}/ncpdp03 -s ${REPORT_ONLY}01
             else
                 runcobol ${OBJ_DIR}/ncpdp03 -s ${REPORT_ONLY}00
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
    -r) REPORT_ONLY=1
        ;;
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
NCPTP00TAP=/usr/upd/pharm/NCPTP00TAP.full
export NCPTP00TAP 

echo Alternate & PDM group listing
date
submit_ncpdp03
date

exit 0
