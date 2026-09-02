#!/bin/sh
#
# Program Name	: tgrp02.sh 
# Description   : add, update, or delete records in the TGRP000MAS master file  
#                 Command line arguments:
#                 
#                 
# Author	: Linda Jefferis
# Date		: 05/04/2018
#		: 
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

usage: tgrp02.sh [-s ${TEST-MODE}]

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

	
# Submit tgrp02 program
submit_tgrp02()
{
       runcobol ${OBJ_DIR}/tgrp02 -s ${TEST_MODE}${DEBUG_MODE}
	RETVAL=$?
}      

#
# Main routine
#
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
    -s) TEST_MODE=1
       ;;
  esac
  shift
done
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        TGRP02PRM=$INFILE
else
	usage
fi
export TGRP02PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        TGRPU02CSV=$OUTFILE
else
        TGRPU02CSV=/usr/lnk/wt/oper-wt/TGRPU02CSV-${DATETM}.csv
fi
export TGRPU02CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        TGRPE02CSV=$RPTFILE
else
        TGRPE02CSV=/usr/lnk/wt/oper-wt/TGRPE02CSV-${DATETM}.csv
fi
export TGRPE02CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   TGRP000MAS=$TGRP000MAS "
echo "   TGRP02PRM=$TGRP02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   TGRPU02CSV=$TGRPU02CSV "
echo "   TGRPE02CSV=$TGRPE02CSV "
submit_tgrp02
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
