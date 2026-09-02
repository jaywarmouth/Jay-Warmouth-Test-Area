#!/bin/sh
#
# Program Name	: rcode02.sh 
# Description   : Update/Add RCODE00MAS records using input parameter text file.
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

usage: rcode02.sh -t -d -f <input file> -o <output file> -r <ErrorReport file>
        -t              - flag to not update RCODE00MAS
        -i <file>       - required, input filename
        -o <file>       - optional, RCODE02UCSV name, default is
                          /usr/lnk/tmp/RCODE02UCSV-datetm.txt
        -r <file>       - optional, RCODE02ECSV filename, default is
                          /usr/lnk/tmp/RCODE02-ERRORS-datetm.txt

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

	
# Submit rcode02 program
submit_rcode02()
{
       runcobol ${OBJ_DIR}/rcode02 -s ${TEST_MODE}${DEBUG_MODE}
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
        RCODE02PRM=${INFILE}
else
	usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        RCODE02UCSV=${OUTFILE}
else
        RCODE02UCSV=/usr/lnk/wt/oper-wt/RCODE02UCSV-${DATETM}.csv
fi

if [ $RPTFILE_FLG = 1 ]
then
        RCODE02ECSV=${RPTFILE}
else
        RCODE02ECSV=/usr/lnk/wt/oper-wt/RCODE02ECSV-${DATETM}.csv
fi

export RCODE02PRM RCODE02UCSV RCODE02ECSV

FG4AUD=$GRPAUD  
  export FG4AUD

date
echo "EXPORT PATHS:"
echo "   RCODE00MAS=$RCODE00MAS "
echo "   RCODE02PRM=$RCODE02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   RCODE02UCSV=$RCODE02UCSV "
echo "   RCODE02ECSV=$RCODE02ECSV "
submit_rcode02
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
