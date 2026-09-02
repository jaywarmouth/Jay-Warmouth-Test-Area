#!/bin/sh
#
# Program Name	: tpm0002.sh 
# Description   : Update/Add TPM00MAS records using input parameter text file.
#                 Command line arguments:
#                 -D = DEBUG
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
DEBUG=" "

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tpm0002.sh -t -d -f <input file> -o <output file> -r <ErrorReport file>
        -t              - flag to not update TPM00MAS
        -f <file>       - required, input filename
        -o <file>       - optional, TPM00UCSV name, default is
                          /home/flim/test/TPM00UCSV-datetm.txt
        -r <file>       - optional, TPM00ECSV filename, default is
                          /home/flim/test/TPM0002-ERRORS-datetm.txt

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

	
# Submit tpm0002 program
submit_tpm0002()
{
       runcobol ${OBJ_DIR}/tpm0002 -s ${TEST_MODE}${DEBUG_MODE} 
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
    -D) DEBUG="D"
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
        TPM00PRM=${INFILE}
else
	usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        TPM00UCSV=${OUTFILE}
else
        TPM00UCSV=/home/flim/test/TPM00UCSV-${DATETM}.txt
fi

if [ $RPTFILE_FLG = 1 ]
then
        TPM00ECSV=${RPTFILE}
else
        TPM00ECSV=/home/flim/test/TPM0002-ERRORS-${DATETM}.txt
fi

export TPM00PRM TPM00UCSV TPM00ECSV

#TPM00MAS=/home/flim/test/TPM00MAS.new
#  export TPM00MAS

date
echo "EXPORT PATHS:"
echo "   TPM00MAS=$TPM00MAS "
echo "   TPM00PRM=$TPM00PRM "
echo "   FG4AUD=$FG4AUD "
echo "   TPM00UCSV=$TPM00UCSV "
echo "   TPM00ECSV=$TPM00ECSV "
submit_tpm0002
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
