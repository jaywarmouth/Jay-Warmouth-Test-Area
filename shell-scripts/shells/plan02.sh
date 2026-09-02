#!/bin/sh
#
# Program Name	: plan02.sh 
# Description   : Update/Add PLAN000MAS records using input parameter text file.
#                 Command line arguments:
#                 
#                 
# Author	: Debbe Adgate 
# Date		: 11/18/2016
# Modifications : Linda Jefferis 11/29/2016 production updates
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
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: plan02.sh -t -d -f <input file> -o <output file> -r <ErrorReport file>
        -t              - flag to not update PLAN000MAS
        -f <file>       - required, input filename
        -o <file>       - optional
        -r <file>       - optional

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

	
# Submit plan02 program
submit_plan02()
{
       runcobol ${OBJ_DIR}/plan02 -s ${TEST_MODE}${DEBUG_MODE}                          
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
    -t) TEST_MODE=1
       ;;
    -d) DEBUG_MODE=1
       ;;
    -f) shift
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


 
#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        PLAN02PRM=${INFILE}
else
	usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        PLANU02CSV=${OUTFILE}
else
        PLANU02CSV=/usr/lnk/wt/oper-wt/PLANU02CSV-${DATETM}.csv
fi

if [ $RPTFILE_FLG = 1 ]
then
        PLANE02CSV=${RPTFILE}
else
        PLANE02CSV=/usr/lnk/wt/oper-wt/PLANE02CSV-${DATETM}.csv
fi

export PLAN02PRM PLANU02CSV PLANE02CSV

FG4AUD=$GRPAUD  
  export FG4AUD

date
echo "EXPORT PATHS:"
echo "   PLAN000MAS=$PLAN000MAS "
echo "   PLAN02PRM=$PLAN02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   PLANU02CSV=$PLANU02CSV "
echo "   PLANE02CSV=$PLANE02CSV "
submit_plan02
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
