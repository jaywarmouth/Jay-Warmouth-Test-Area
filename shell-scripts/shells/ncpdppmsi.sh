#!/bin/ksh
#
# Program Name  : ncpdppmsi.sh
# Description   : PMSI Pharmacy File Update
#                 Command line arguments:
#                 -d date of file (mmdd)
# Author        : Mike Paulus
# Date          : 09/27/2007
# Modifications : 04/10/2008 - Added logic for new .lin input file  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%y`
OBJ_DIR=/usr/lnk/obj
ELIG_DIR="/usr/lnk/elig_in"
PHARM_DIR="/usr/upd/pharm/pmsi"
DATE="null"
SYS="0103"
CLIENT="ps"
AUDIT_DIR="/usr/lnk/audit"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ncpdppmsi.sh -d <mmdd>

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


# Submit ncpdppmsi program
submit_ncpdppmsi()
{
     runcobol ${OBJ_DIR}/ncpdppmsi 
         
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
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

PMSIXLSTAP=${ELIG_DIR}/${CLIENT}n${DATE}.lin; export PMSIXLSTAP
FG4AUD=${AUDIT_DIR}/PHAAUD; export FG4AUD

PMSIADDRPT=${PMSIADDRPT}-${DATE}; export PMSIADDRPT
PMSICHGRPT=${PMSICHGRPT}-${DATE}; export PMSICHGRPT
PMSIERROR=${PMSIERROR}-${DATE}; export PMSIERROR
PMSIREPORT=${PMSIREPORT}-${DATE}; export PMSIREPORT


umask 000

echo "PMSI Pharmacy File Update"
date
submit_ncpdppmsi
date

exit 0
