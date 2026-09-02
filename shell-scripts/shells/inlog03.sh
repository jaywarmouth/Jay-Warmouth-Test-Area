#!/bin/sh
#
# Program Name	: inlog03.sh 
# Description   : add, update, or delete records in the INLOG00MAS master file  
#                 Command line arguments:
#                 
#                 
# Author	: Linda Jefferis
# Date		: 05/02/2018
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

usage: inlog03.sh [-s ${TEST-MODE}]

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

	
# Submit inlog03 program
submit_inlog03()
{
       runcobol ${OBJ_DIR}/inlog03 -s ${TEST_MODE}${DEBUG_MODE}
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
        INLOG03PRM=$INFILE
else
	usage
fi
export INLOG03PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        INLOGU03CSV=$OUTFILE
else
        INLOGU03CSV=/usr/lnk/wt/oper-wt/INLOGU03CSV-${DATETM}.txt
fi
export INLOGU03CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        INLOGE03CSV=$RPTFILE
else
        INLOGE03CSV=/usr/lnk/wt/oper-wt/INLOGE03CSV-${DATETM}.txt
fi
export INLOGE03CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   INLOG00MAS=$INLOG00MAS "
echo "   INLOG03PRM=$INLOG03PRM "
echo "   FG4AUD=$FG4AUD "
echo "   INLOGU03CSV=$INLOGU03CSV "
echo "   INLOGE03CSV=$INLOGE03CSV "
submit_inlog03
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
