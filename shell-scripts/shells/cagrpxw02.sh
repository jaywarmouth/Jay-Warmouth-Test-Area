#!/bin/sh
#
# Program Name	: cagrpxw02.sh 
# Description   : add, update, or delete records in the CAGRPXWMAS master file  
#                 Command line arguments:
#                 
#                 
# Author	: Patrick Murphy
# Date		: 03/20/2025
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE="N"
DEBUG_MODE="N"
RETVAL=0
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cagrpxw02.sh [-s ${TEST-MODE}]

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

	
# Submit cagrpxw02 program
submit_cagrpxw02()
{
       runcobol ${OBJ_DIR}/cagrpxw02 -a ${DEBUG_MODE}${TEST_MODE} 
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
  esac
  shift
done
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        CAGRPXW2PRM=$INFILE
else
	usage
fi
export CAGRPXW2PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        CAGRPXWU2CSV=$OUTFILE
else
        CAGRPXWU2CSV=/usr/lnk/wt/oper-wt/CAGRPXWU2CSV-${DATETM}.txt
fi
export CAGRPXWU2CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        CAGRPXWE2CSV=$RPTFILE
else
        CAGRPXWE2CSV=/usr/lnk/wt/oper-wt/CAGRPXWE2CSV-${DATETM}.txt
fi
export CAGRPXWE2CSV

FG4AUD=$FG4AUD
   export FG4AUD

CAGRPXWMAS=$CAGRPXWMAS
   export CAGRPXWMAS

date
echo "EXPORT PATHS:"
echo "   CAGRPXWMAS=$CAGRPXWMAS "
echo "   CAGRPXW2PRM=$CAGRPXW2PRM "
echo "   FG4AUD=$FG4AUD "
echo "   CAGRPXWU2CSV=$CAGRPXWU2CSV "
echo "   CAGRPXWE2CSV=$CAGRPXWE2CSV "
submit_cagrpxw02
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
