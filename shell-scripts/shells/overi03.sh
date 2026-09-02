#!/bin/sh
# 
# Program Name	: overi03.sh
# Description   : Terminate overrides based on records on override work file
#                 Command line arguments:
#                 -t test-mode
#		  -f <OVERI00WRK file>
#		  -r <OVREPORT file>

# Author	: Peggy Voytilla
# Date		: 11/18/2016
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_IN="null"
TEST_MODE=0
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0
INFILE_FLG=0
RPTFILE_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: OVERI03.sh -t -f <OVERI00WRK> -r <OVREPORT>

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


# Submit overi03 program
submit_overi03()
{
     runcobol ${OBJ_DIR}/overi03 -s ${TEST_MODE} 
     RETVAL=$?
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INFILE_FLG=1
        INFILE=$1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RPTFILE_FLG=1
        RPTFILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
	OVERI00WRK=${INFILE}
else
	usage
fi
if [ $RPTFILE_FLG = 1 ]
then
        OVREPORT=${RPTFILE}
else
        OVREPORT=/usr/lnk/tmp/OVERI03-REPORT-${DATETM}.csv
fi

export OVREPORT OVERI00WRK

echo "Delete Overrides based on Override Work File"
date
echo "   OVERI00MAS=$OVERI00MAS"
echo "   OVERI00WRK=$OVERI00WRK"
echo "   OVREPORT=$OVREPORT"
submit_overi03 
date

exit $RETVAL
