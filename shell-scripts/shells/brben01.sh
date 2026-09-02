#!/bin/sh
#
# Program Name	: brben01.sh 
# Description   : add, update, or delete records in the BRBEN00MAS master file  
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

usage: brben01.sh [-a ${TEST-MODE}]

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

	
# Submit brben01 program
submit_brben01()
{
       runcobol ${OBJ_DIR}/brben01 -s ${TEST_MODE}${DEBUG_MODE}
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
        BRBEN01PRM=$INFILE
else
	usage
fi
export BRBEN01PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        BRBENU1CSV=$OUTFILE
else
        BRBENU1CSV=/usr/lnk/wt/oper-wt/BRBENU1CSV-${DATETM}.csv
fi
export BRBENU1CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        BRBENE1CSV=$RPTFILE
else
        BRBENE1CSV=/usr/lnk/wt/oper-wt/BRBENE1CSV-${DATETM}.csv
fi
export BRBENE1CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   BRBEN00MAS=$BRBEN00MAS "
echo "   BRBEN01PRM=$BRBEN01PRM "
echo "   FG4AUD=$FG4AUD "
echo "   BRBENU1CSV=$BRBENU1CSV "
echo "   BRBENE1CSV=$BRBENE1CSV "
submit_brben01
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
