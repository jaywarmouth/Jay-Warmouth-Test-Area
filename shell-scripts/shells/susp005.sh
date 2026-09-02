#!/bin/sh
#
# Program Name	: susp005.sh 
# Description   : add, update, or delete records in the SUSP000MAS master file  
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

usage: susp005.sh [-s ${TEST-MODE}]

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

	
# Submit susp005 program
submit_susp005()
{
       runcobol ${OBJ_DIR}/susp005 -s ${TEST_MODE}${DEBUG_MODE}
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
        SUSP005PRM=$INFILE
else
	usage
fi
export SUSP005PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        SUSPU05CSV=$OUTFILE
else
        SUSPU05CSV=/usr/lnk/wt/oper-wt/SUSPU05CSV-${DATETM}.csv
fi
export SUSPU05CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        SUSPE05CSV=$RPTFILE
else
        SUSPE05CSV=/usr/lnk/wt/oper-wt/SUSPE05CSV-${DATETM}.csv
fi
export SUSPE05CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   SUSP000MAS=$SUSP000MAS "
echo "   SUSP005PRM=$SUSP005PRM "
echo "   FG4AUD=$FG4AUD "
echo "   SUSPU05CSV=$SUSPU05CSV "
echo "   SUSPE05CSV=$SUSPE05CSV "
submit_susp005
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
