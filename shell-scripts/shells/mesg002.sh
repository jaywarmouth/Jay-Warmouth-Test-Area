#!/bin/sh
#
# Program Name	: mesg002.sh 
# Description   : Update/Add MESG000MAS records using input parameter text file.
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
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mesg002.sh -t -d -f <input file> -o <output file> -r <ErrorReport file>
        -t              - flag to not update MESG000MAS
        -f <file>       - required, input filename
        -o <file>       - optional, MESG0U02CSV name
        -r <file>       - optional, MESG0E02CSV filename

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

	
# Submit mesg002 program
submit_mesg002()
{
       runcobol ${OBJ_DIR}/mesg002 -s ${TEST_MODE}${DEBUG_MODE}               
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
        MESG002PRM=${INFILE}
else
	usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        MESG0U02CSV=${OUTFILE}
else
        MESG0U02CSV=/usr/lnk/wt/oper-wt/MESG0U02CSV-${DATETM}.csv
fi

if [ $RPTFILE_FLG = 1 ]
then
        MESG0E02CSV=${RPTFILE}
else
        MESG0E02CSV=/usr/lnk/wt/oper-wt/MESG0E02CSV-${DATETM}.csv
fi

export MESG002PRM MESG0U02CSV MESG0E02CSV

FG4AUD=$CRDAUD  
  export FG4AUD

date
echo "EXPORT PATHS:"
echo "   MESG000MAS=$MESG000MAS "
echo "   MESG002PRM=$MESG002PRM "
echo "   FG4AUD=$FG4AUD "
echo "   MESG0U02CSV=$MESG0U02CSV "
echo "   MESG0E02CSV=$MESG0E02CSV "
submit_mesg002
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
