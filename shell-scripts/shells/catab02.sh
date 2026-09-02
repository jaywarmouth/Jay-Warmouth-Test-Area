#!/bin/sh
#
# Program Name	: catab02.sh 
# Description   : Update/Add CATAB00MAS records using input parameter text file.
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

usage: catab02.sh -t -d -f <input file> -o <output file> -r <ErrorReport file>
        -t              - flag to not update CATAB00MAS
        -f <file>       - required, input filename
        -o <file>       - optional, CATAB02UCSV name, default is
                          /usr/lnk/wt/oper-wt/CATAB02UCSV-datetm.csv
        -r <file>       - optional, CATAB02ECSV filename, default is
                          /usr/lnk/wt/oper-wt/CATAB02ECSV-datetm.csv

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

	
# Submit catab02 program
submit_catab02()
{
       runcobol ${OBJ_DIR}/catab02 -s ${TEST_MODE}${DEBUG_MODE}                          
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
        CATAB02PRM=${INFILE}
else
	usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        CATAB02UCSV=${OUTFILE}
else
        CATAB02UCSV=/usr/lnk/wt/oper-wt/CATAB02UCSV-${DATETM}.csv
fi

if [ $RPTFILE_FLG = 1 ]
then
        CATAB02ECSV=${RPTFILE}
else
        CATAB02ECSV=/usr/lnk/wt/oper-wt/CATAB02ECSV-${DATETM}.csv
fi

export CATAB02PRM CATAB02UCSV CATAB02ECSV

FG4AUD=$CRDAUD  
  export FG4AUD

date
echo "EXPORT PATHS:"
echo "   CATAB00MAS=$CATAB00MAS "
echo "   CATAB02PRM=$CATAB02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   CATAB02UCSV=$CATAB02UCSV "
echo "   CATAB02ECSV=$CATAB02ECSV "
submit_catab02
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
