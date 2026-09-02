#!/bin/sh
#
# Program Name	: ndcom02.sh 
# Description   : add, update, or delete records in the NDCOM00MAS master file  
#                 Command line arguments:
#                 
#                 
# Author	: Greg Vernon
# Date		: 11/16/2017
# Modifications : 12/06/2017 - Changes for production version. 
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

usage: ndcom02.sh [-s ${TEST-MODE}]

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

	
# Submit ndcom02 program
submit_ndcom02()
{
       runcobol ${OBJ_DIR}/ndcom02 -s ${TEST_MODE}${DEBUG_MODE}
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
        NDCOMPRM=$INFILE
else
	usage
fi
export NDCOMPRM

if [ ${OUTFILE_FLG} = 1 ]
then
        NDCOMU02CSV=$OUTFILE
else
        NDCOMU02CSV=/usr/lnk/wt/oper-wt/NDCOMU02CSV-${DATETM}.csv
fi
export NDCOMU02CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        NDCOME02CSV=$RPTFILE
else
        NDCOME02CSV=/usr/lnk/wt/oper-wt/NDCOME02CSV-${DATETM}.csv
fi
export NDCOME02CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   NDCOM000MAS=$NDCOM000MAS "
echo "   NDCOMPRM=$NDCOMPRM "
echo "   FG4AUD=$FG4AUD "
echo "   NDCOMU02CSV=$NDCOMU02CSV "
echo "   NDCOME02CSV=$NDCOME02CSV "
submit_ndcom02
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
