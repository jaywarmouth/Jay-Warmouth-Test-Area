#!/bin/ksh
#
# Program Name  : ncpdp02.sh
# Description   : NCPDP File Update
# Author        : Christina Harris
# Date          : 11/20/97
# Modifications : 11/25/98 - Changed assignment of FG4AUD variable  (LSJ)
#		  09/11/2001 - Changed FG4AUD to be assigned to PHAAUD  (LSJ)
#		: 02/21/2006 - Added umask command temporarily  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%y`
OBJ_DIR=/usr/lnk/obj
USER=""
SWITCH_FLAG=0
FULLFILE_FLAG=0
REPORT_ONLY=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ncpdp02.sh [ -r ] [ -s ] [ -f ]

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


# Submit ncpdp02 program
submit_ncpdp02()
{
        if [ ${SWITCH_FLAG} = 1 ]
        then
             if [ ${FULLFILE_FLAG} = 1 ]
             then
                 runcobol ${OBJ_DIR}/ncpdp02 -s ${REPORT_ONLY}11 -a ${USER}'           '
             else
                 runcobol ${OBJ_DIR}/ncpdp02 -s ${REPORT_ONLY}10 -a ${USER}'           '
             fi
        else
             if [ ${FULLFILE_FLAG} = 1 ]
             then
                 runcobol ${OBJ_DIR}/ncpdp02 -s ${REPORT_ONLY}01 -a ${USER}'           '

             else
                 runcobol ${OBJ_DIR}/ncpdp02 -s ${REPORT_ONLY}00 -a ${USER}'           '
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
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USER=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD

umask 000

echo Alternate and PDM group listing
date
submit_ncpdp02
date

exit 0
