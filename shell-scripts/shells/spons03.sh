#!/bin/sh
#
# Program Name	: spons03.sh 
# Description   : add, update, or delete records in the SPONS00MAS master file  
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

usage: spons03.sh [-s ${TEST-MODE}]

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

	
# Submit spons03 program
submit_spons03()
{
       runcobol ${OBJ_DIR}/spons03 -s ${TEST_MODE}${DEBUG_MODE}
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
        SPONS03PRM=$INFILE
else
	usage
fi
export SPONS03PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        SPONSU03CSV=$OUTFILE
else
        SPONSU03CSV=/usr/lnk/wt/oper-wt/SPONSU03CSV-${DATETM}.csv
fi
export SPONSU03CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        SPONSE03CSV=$RPTFILE
else
        SPONSE03CSV=/usr/lnk/wt/oper-wt/SPONSE03CSV-${DATETM}.csv
fi
export SPONSE03CSV

FG4AUD=${GRPAUD}
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   SPONS00MAS=$SPONS00MAS "
echo "   SPONS03PRM=$SPONS03PRM "
echo "   FG4AUD=$FG4AUD "
echo "   SPONSU03CSV=$SPONSU03CSV "
echo "   SPONSE03CSV=$SPONSE03CSV "
submit_spons03
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
