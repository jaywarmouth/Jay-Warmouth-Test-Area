#!/bin/bash
# Program Name	: numot01.sh
# Description   : add, update, or delete records in the NUMOT00MAS file  
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

usage: numot01.sh [-t ${TEST-MODE}]

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

	
# Submit numot01 program
submit_numot01()
{

       runcobol ${OBJ_DIR}/numot01 -s ${TEST_MODE}${DEBUG_MODE}                      
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

 
#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        NUMOT01PRM=$INFILE
else
        usage
fi
export NUMOT01PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        NUMOT01UCSV=$OUTFILE
else
        NUMOT01UCSV=/usr/lnk/wt/oper-wt/NUMOT01UCSV-${DATETM}.csv
fi
export NUMOT01UCSV
if [ ${RPTFILE_FLG} = 1 ]
then
        NUMOT01ECSV=$RPTFILE
else
        NUMOT01ECSV=/usr/lnk/wt/oper-wt/NUMOT01ECSV-${DATETM}.csv
fi
export NUMOT01ECSV

FG4AUD=${FG4AUD}
   export FG4AUD

date
echo "EXPORT PATHS:"

echo "   NUMOT01PRM=$NUMOT01PRM "
echo "   NUMOT00MAS=$NUMOT00MAS "
echo "   FG4AUD=$FG4AUD "
echo "   NUMOT01UCSV=$NUMOT01UCSV "
echo "   NUMOT01ECSV=$NUMOT01ECSV "
submit_numot01
echo  "   RET_CODE=$RETVAL "
date


exit 0
