#!/bin/ksh
#
# Program Name	: rever05.sh 
# Description   : add, update, or delete records in the REVER00MAS/CLAIMAS master file  
#                 
#                 Need parameter file to force hundreds of Reversals in Reversal Table
#                   to create credit claims - (TD-16144/102042) - 596.
#                 
# Author	: Javier Garcia
# Date		: 08/18/2026
# Modifications :
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

usage: rever05.jg [-s ${TEST-MODE}]

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

	
# Submit rever05 program
submit_rever05()
{
       runcobol ${OBJ_DIR}/rever05 -s ${TEST_MODE}${DEBUG_MODE}
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
        REVER05PRM=$INFILE  
else
	usage
fi

export REVER05PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        REVERU05CSV=$OUTFILE
else
        REVERU05CSV=/usr/lnk/wt/oper-wt/REVERU05CSV-${DATETM}.csv
fi
export REVERU05CSV

if [ ${RPTFILE_FLG} = 1 ]
then
       REVERE05CSV=$RPTFILE
 
else
       REVERE05CSV=/usr/lnk/wt/oper-wt/REVERE05CSV-${DATETM}.csv
fi
export REVERE05CSV

FG4AUD=$FG4AUD
   export FG4AUD

REVER05PRM=$INFILE
  export REVER05PRM

date
echo "EXPORT PATHS:"
echo "   REVER00MAS=$REVER00MAS "
echo "   REVER05PRM=$REVER05PRM "
echo "   FG4AUD=$FG4AUD "
echo "   REVERU05CSV=$REVERU05CSV "
echo "   REVERE05CSV=$REVERE05CSV "
submit_rever05
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
