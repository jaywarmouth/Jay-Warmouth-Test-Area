#!/bin/sh
#
# Program Name	: rebadld.sh 
# Description   : Update/Add REBAD00MAS records using input parameter text file.
#                 Command line arguments:
#                 
#                 
# Author	: Debbe Adgate 
# Date		: 03/05/2020
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
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebadld.sh -t -d -f <input file> -o <output file> -r <ErrorReport file>
        -t              - flag to not update REBAD00MAS
        -f <file>       - required, input filename
        -o <file>       - optional, REBADU02CSV name, default is
                          /usr/lnk/tmp/REBADU02CSV-datetm.txt
        -r <file>       - optional, REBADE02CSV filename, default is
                          /usr/lnk/tmp/REBAD-ERRORS-datetm.txt

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
submit_rebadld()
{
       runcobol ${OBJ_DIR}/rebadld -s ${TEST_MODE}${DEBUG_MODE}
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


 
#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        REBADPRM=${INFILE}
else
	usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        REBADU02CSV=${OUTFILE}
else
        REBADU02CSV=/usr/lnk/wt/oper-wt/REBADU02CSV-${DATETM}.csv
fi

if [ $RPTFILE_FLG = 1 ]
then
        REBADE02CSV=${RPTFILE}
else
        REBADE02CSV=/usr/lnk/wt/oper-wt/REBADE02CSV-${DATETM}.csv
fi

export REBADBPRM REBADU02CSV REBADE02CSV

FG4AUD=$FG4AUD  
  export FG4AUD

date
echo "EXPORT PATHS:"
echo "   REBAD00MAS=$REBAD00MAS "
echo "   REBADBPRM=$REBADBPRM "
echo "   FG4AUD=$FG4AUD "
echo "   REBADU02CSV=$REBADU02CSV "
echo "   REBADE02CSV=$REBADE02CSV "
submit_rebadld
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
