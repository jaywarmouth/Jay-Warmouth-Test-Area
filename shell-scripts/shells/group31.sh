#!/bin/sh
#
# Program Name	: group31.sh 
# Description   : add, update, or delete records in the GROUP00MAS master file  
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

usage: group31.sh [-s ${TEST-MODE}]

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

	
# Submit group31 program
submit_group31()
{
       runcobol ${OBJ_DIR}/group31 -s ${TEST_MODE}${DEBUG_MODE}
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
        GROUP31PRM=$INFILE
else
	usage
fi
export GROUP31PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        GROUPU31CSV=$OUTFILE
else
        GROUPU31CSV=/usr/lnk/wt/oper-wt/GROUPU31CSV-${DATETM}.txt
fi
export GROUPU31CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        GROUPE31CSV=$RPTFILE
else
        GROUPE31CSV=/usr/lnk/wt/oper-wt/GROUPE31CSV-${DATETM}.txt
fi
export GROUPE31CSV

FG4AUD=$GRPAUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   GROUP00MAS=$GROUP00MAS "
echo "   GROUP31PRM=$GROUP31PRM "
echo "   FG4AUD=$FG4AUD "
echo "   GROUPU31CSV=$GROUPU31CSV "
echo "   GROUPE31CSV=$GROUPE31CSV "
submit_group31
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
