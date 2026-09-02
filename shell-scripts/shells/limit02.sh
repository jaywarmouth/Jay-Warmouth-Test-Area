#!/bin/sh
#
# Program Name	: limit02.sh 
# Description   : add, update, or delete records in the LIMIT00MAS master file  
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

usage: limit02.sh 

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

	
# Submit limit02 program
submit_limit02()
{
       runcobol ${OBJ_DIR}/limit02 -s ${TEST_MODE}${DEBUG_MODE}
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
        LIMITPRM=$INFILE
else
	usage
fi
export LIMITPRM

if [ ${OUTFILE_FLG} = 1 ]
then
        LIMITU02CSV=$OUTFILE
else
        LIMITU02CSV=/usr/lnk/wt/oper-wt/LIMITU02CSV-${DATETM}.csv
fi
export LIMITU02CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        LIMITE02CSV=$RPTFILE
else
        LIMITE02CSV=/usr/lnk/wt/oper-wt/LIMITE02CSV-${DATETM}.csv
fi
export LIMITE02CSV

FG4AUD=$LIMAUD
   export LIMAUD

date
echo "EXPORT PATHS:"
echo "   LIMIT00MAS=$LIMIT00MAS "
echo "   LIMITPRM=$LIMITPRM "
echo "   FG4AUD=$FG4AUD "
echo "   LIMITU02CSV=$LIMITU02CSV "
echo "   LIMITE02CSV=$LIMITE02CSV "
submit_limit02
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
