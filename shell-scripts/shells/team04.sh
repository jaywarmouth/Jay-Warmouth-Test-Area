#!/bin/sh
#
# Program Name	: team04.sh 
# Description   : add, update, or delete records in the TEAM000MAS master file  
#                 Command line arguments:
#                 
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

usage: team04.sh [-s ${TEST-MODE}]

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

	
# Submit team04 program
submit_team04()
{
       runcobol ${OBJ_DIR}/team04 -s ${TEST_MODE}${DEBUG_MODE}
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
        TEAM000PRM=$INFILE
else
	usage
fi
export TEAM000PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        TEAM000UCSV=$OUTFILE
else
        TEAM000UCSV=/usr/lnk/wt/oper-wt/TEAM000UCSV-${DATETM}.csv
fi
export TEAM000UCSV
if [ ${RPTFILE_FLG} = 1 ]
then
        TEAM000ECSV=$RPTFILE
else
        TEAM000ECSV=/usr/lnk/wt/oper-wt/TEAM000ECSV-${DATETM}.csv
fi
export TEAM000ECSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   TEAM000MAS=$TEAM000MAS "
echo "   TEAM000PRM=$TEAM000PRM "
echo "   FG4AUD=$FG4AUD "
echo "   TEAM000UCSV=$TEAM000UCSV "
echo "   TEAM000ECSV=$TEAM000ECSV "
submit_team04
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
