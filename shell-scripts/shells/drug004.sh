#!/bin/sh
#
# Program Name	: drug004.sh 
# Description   : add, update, or delete records in the DRUG000MAS master file  
#                 Command line arguments:
#                 
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

usage: drug004.sh [-s ${TEST-MODE}]

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

	
# Submit drug004 program
submit_drug004()
{
       runcobol ${OBJ_DIR}/drug004 -s ${TEST_MODE}${DEBUG_MODE}
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
        DRUG004PRM=$INFILE
else
	usage
fi
export DRUG004PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        DRUG00U04CSV=$OUTFILE
else
        DRUG00U04CSV=/usr/lnk/wt/oper-wt/DRUG00U04CSV-${DATETM}.txt
fi
export DRUG00U04CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        DRUG00E04CSV=$RPTFILE
else
        DRUG00E04CSV=/usr/lnk/wt/oper-wt/errorrpt-${DATETM}.txt
fi
export DRUG00E04CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   DRUG000MAS=$DRUG000MAS "
echo "   DRUG004PRM=$DRUG004PRM "
echo "   FG4AUD=$FG4AUD "
echo "   DRUG00U04CSV=$DRUG00U04CSV "
echo "   DRUG00E04CSV=$DRUG00E04CSV "
submit_drug004
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
