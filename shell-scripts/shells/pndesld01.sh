#!/bin/sh
#
# Program Name	: pndesld01.sh 
# Description   : add, update, or delete records in the PNDES00MAS master file  
#                 Command line arguments:
#                 
#                 
# Author	: Greg Vernon
# Date		: 11/16/2017
# Modifications : 01/12/2018 - Changes for production version. 
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

usage: pndesld01.sh

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

	
# Submit pndesld01 program
submit_pndesld01()
{
       runcobol ${OBJ_DIR}/pndesld01 -s ${TEST_MODE}${DEBUG_MODE}
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
    -t) TEST_MODE=1
       ;;
  esac
  shift
done
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        PNDESBPRM=$INFILE
else
	usage
fi
export PNDESBPRM

if [ ${OUTFILE_FLG} = 1 ]
then
        PNDESU02CSV=$OUTFILE
else
        PNDESU02CSV=/usr/lnk/wt/oper-wt/PNDESU02CSV-${DATETM}.csv
fi
export PNDESU02CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        PNDESE02CSV=$RPTFILE
else
        PNDESE02CSV=/usr/lnk/wt/oper-wt/PNDESE02CSV-${DATETM}.csv
fi
export PNDESE02CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   PNDES00MAS=$PNDES00MAS "
echo "   PNDESBPRM=$PNDESBPRM "
echo "   FG4AUD=$FG4AUD "
echo "   PNDESU02CSV=$PNDESU02CSV "
echo "   PNDESE02CSV=$PNDESE02CSV "
submit_pndesld01
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
