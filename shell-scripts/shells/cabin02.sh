#!/bin/sh
#
# Program Name	: cabin02.sh 
# Description   : add, update, or delete records in the CABIN00MAS  master file  
#                 Command line arguments:
#                 Switches:
#                 -t Test mode (no CABIN00MAS file rewrites)
#                 -i <input file> - required
#                 -o <output CABINU02CSV> - optional
#                 -r <output CABINE02CSV> - optional                 
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

usage: cabin02.jg [-s ${TEST-MODE}]

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

	
# Submit cabin02 program
submit_cabin02()
{
       runcobol ${OBJ_DIR}/cabin02 -s ${TEST_MODE}${DEBUG_MODE}
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
        CABIN02PRM=$INFILE  
else
	usage
fi

export CABIN02PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        CABINU02CSV=$OUTFILE
else
        CABINU02CSV=/usr/lnk/wt/oper-wt/CABINU02CSV-${DATETM}.csv
fi
export CABINU02CSV

if [ ${RPTFILE_FLG} = 1 ]
then
        CABINE02CSV=$RPTFILE
else
        CABINE02CSV=/usr/lnk/wt/oper-wt/CABINE02CSV-${DATETM}.csv
fi
export CABINE02CSV

FG4AUD=${FG4AUD}
  export FG4AUD


date
echo "EXPORT PATHS:"
echo "   CABIN00MAS=$CABIN00MAS "
echo "   CABIN02PRM=$CABIN02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   CABINU02CSV=$CABINU02CSV "
echo "   CABINE02CSV=$CABINE02CSV "
submit_cabin02
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
