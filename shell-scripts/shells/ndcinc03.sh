#!/bin/sh
#
# Program Name	: ndcinc03.sh 
# Description   : add, update, or delete records in the NDCINC0MAS master file  
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

usage: ndcinc03.sh [-t ${TEST-MODE}]

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

	
# Submit ndcinc03 program
submit_ndcinc03()
{
       runcobol ${OBJ_DIR}/ndcinc03 -s ${TEST_MODE}${DEBUG_MODE}
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
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        NDCINC03PRM=$INFILE
else
	usage
fi
export NDCINC03PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        NDCINCU03CSV=$OUTFILE
else
        NDCINCU03CSV=/usr/lnk/wt/oper-wt/NDCINCU03CSV-${DATETM}.csv
fi
export NDCINCU03CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        NDCINCE03CSV=$RPTFILE
else
        NDCINCE03CSV=/usr/lnk/wt/oper-wt/NDCINCE03CSV-${DATETM}.csv
fi
export NDCINCE03CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   NDCINC0MAS=$NDCINC0MAS "
echo "   NDCINC03PRM=$NDCINC03PRM "
echo "   FG4AUD=$FG4AUD "
echo "   NDCINCU03CSV=$NDCINCU03CSV "
echo "   NDCINCE03CSV=$NDCINCE03CSV "
submit_ndcinc03
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
