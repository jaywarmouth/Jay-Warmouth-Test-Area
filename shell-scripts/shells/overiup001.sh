#!/bin/sh
#
# Program Name	: overiup001.sh
# Description   : OVERI00MAS Override Master Update.
# Command line arguments:
#                 -t test mode
#                 -f <input file> - optional, default is /usr/lnk/tmp/OVERI-PARMFILE.txt
#                 -o <output OVERI00CSV> - optional, default is /usr/lnk/tmp/OVERI00CSV.txt
# Author	: John Shrigley
# Date		: 04/25/2016
# Modifications : 04/28/2016 - Updates for production version TT3200-46             
#               : 06/15/2016 - Corrections for issues with script:
#                       Missing "-s" in runcobol command
#                       Missing logic for indicated command line options for files
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
RETVAL=0
FILE_FLAG=0
OUTFILE_FLG=0
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: overiup001.sh 

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit overiup001 program
submit_overiup001()
{
     runcobol ${OBJ_DIR}/overiup001 -s ${TEST_MODE} 
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        OUTFILE=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

if [ ${FILE_FLAG} = 1 ]
then
        PARMFILE=${FILE}
else
        PARMFILE=/usr/lnk/tmp/OVERI-PARMFILE.txt
fi
export PARMFILE

if [ ${OUTFILE_FLG} = 1 ]
then
        OVERI00CSV=${OUTFILE}
else
        OVERI00CSV=/usr/lnk/tmp/OVERI00CSV.txt
fi
export OVERI00CSV

FG4AUD=$FG4AUD
  export FG4AUD


echo "Override Master (OVERI00MAS) Update"
date
echo "EXPORT PATHS:"
echo "   OVERI00MAS=${OVERI00MAS}"
echo "   OVERI00CSV=${OVERI00CSV}"
echo "   FG4AUD=${FG4AUD}"
echo "   PARMFILE=${PARMFILE}"

submit_overiup001
date

exit $RETVAL
