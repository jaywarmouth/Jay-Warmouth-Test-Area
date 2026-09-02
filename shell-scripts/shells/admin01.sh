#!/bin/sh
#
# Program Name	: admin01.sh 
# Description   : add, update, or delete records in the ADMIN00MAS master file  
#                 Command line arguments:
#                 
#                 
# Author	: Linda Jefferis
# Date		: 11/14/2018
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

usage: admin01.sh [-s ${TEST-MODE}]

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

	
# Submit admin01 program
submit_admin01()
{
       runcobol ${OBJ_DIR}/admin01 -s ${TEST_MODE}${DEBUG_MODE}
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
        ADMIN01PRM=$INFILE
else
	usage
fi
export ADMIN01PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        ADMINU01CSV=$OUTFILE
else
        ADMINU01CSV=/usr/lnk/wt/oper-wt/ADMINU01CSV-${DATETM}.txt
fi
export ADMINU01CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        ADMINE01CSV=$RPTFILE
else
        ADMINE01CSV=/usr/lnk/wt/oper-wt/ADMINE01CSV-${DATETM}.txt
fi
export ADMINE01CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   ADMIN00MAS=$ADMIN00MAS "
echo "   ADMIN01PRM=$ADMIN01PRM "
echo "   FG4AUD=$FG4AUD "
echo "   ADMINU01CSV=$ADMINU01CSV "
echo "   ADMINE01CSV=$ADMINE01CSV "
submit_admin01
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
