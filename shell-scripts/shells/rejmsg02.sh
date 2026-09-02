#!/bin/sh
#
# Program Name	: rejmsg02.sh 
# Description   : add, update, or delete records in the REJMSG0MAS master file  
#                 Command line arguments:
#                 
#                 
# Author	: Bill Swidal
# Date		: 11/18/2022
# Modifications :  
#		
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
DEBUG_MODE=0
RETVAL=0
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rejmsg02.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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

# Submit tgrp02 program
submit_rejmsg02()
{
       runcobol ${OBJ_DIR}/rejmsg02 -a ${TEST_MODE}${DEBUG_MODE}
        RETVAL=$?
}

#
# Main routine
#

# Parse environment variables
parse_env

#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INFILE_FLG=1
        INFILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        OUTFILE=$1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RPTFILE_FLG=1
        RPTFILE=$1
        ;;
    -t) TEST_MODE=1
       ;;
  esac
  shift
done 

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        REJMSG02PRM=$INFILE
else
        usage
fi
export REJMSG02PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        REJMSG02UCSV=$OUTFILE
else
        REJMSG02UCSV=/usr/lnk/wt/oper-wt/REJMSG02UCSV-${DATETM}.csv
fi
export REJMSG02UCSV
if [ ${RPTFILE_FLG} = 1 ]
then
        REJMSG02ECSV=$RPTFILE
else
        REJMSG02ECSV=/usr/lnk/wt/oper-wt/REJMSG02ECSV-${DATETM}.csv
fi
export REJMSG02ECSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "  REJMSG0MAS=$REJMSG0MAS "
echo "  REJMSG02PRM=$REJMSG02PRM "
echo "  REJMSG02UCSV=$REJMSG02UCSV "
echo "  REJMSG02ECSV=$REJMSG02ECSV "
echo "  FG4AUD=$FG4AUD "
submit_rejmsg02
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
