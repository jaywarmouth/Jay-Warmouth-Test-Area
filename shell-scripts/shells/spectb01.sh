#!/bin/sh
#
# Program Name	: spectb01.sh 
# Description   : add, update, or delete records in the SPECTB00MAS master file  
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

usage: spectb01.sh [-a ${TEST-MODE}]

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

	
# Submit spectb01 program
submit_spectb01()
{
       runcobol ${OBJ_DIR}/spectb01 -a ${TEST_MODE}${DEBUG_MODE}
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
        PARMFILE=$INFILE
else
	usage
fi
export PARMFILE

if [ ${OUTFILE_FLG} = 1 ]
then
        SPECTB01UCSV=$OUTFILE
else
        SPECTB01UCSV=/usr/lnk/wt/oper-wt/SPECTB01UCSV-${DATETM}.csv
fi
export SPECTB01UCSV
if [ ${RPTFILE_FLG} = 1 ]
then
        SPECTB01ECSV=$RPTFILE
else
        SPECTB01ECSV=/usr/lnk/wt/oper-wt/SPECTB01ECSV-${DATETM}.csv
fi
export SPECTB01ECSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   SPECTB0MAS=$SPECTB0MAS "
echo "   PARMFILE=$PARMFILE "
echo "   FG4AUD=$FG4AUD "
echo "   SPECTB01UCSV=$SPECTB01UCSV "
echo "   SPECTB01ECSV=$SPECTB01ECSV "
submit_spectb01
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
