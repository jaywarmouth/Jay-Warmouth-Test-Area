#!/bin/sh
#
# Program Name	: excepup001.sh
# Description   : EXCEP00MAS Override Master Update.
# Command line arguments:
#                 -t test mode
#                 -f <input file> - optional, default is /usr/lnk/tmp/EXCEP-PARMFILE.txt
#                 -o <output EXCEP00CSV> - optional, default is /usr/lnk/tmp/EXCEP00CSV.txt
# Author	: Linda Jefferis
# Date		: 05/16/2016 (TT15387-2)
#		: 06/15/2016 - Corrections for issues with script:
#			Missing "-s" in runcobol command 
#			Missing logic for indicated command line options for files
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

usage: excepup001.sh 

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

# Submit excepup001 program
submit_excepup001()
{
     runcobol ${OBJ_DIR}/excepup001 -s ${TEST_MODE} 
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
        PARMFILE=/usr/lnk/tmp/EXCEP-PARMFILE.txt
fi
export PARMFILE

if [ ${OUTFILE_FLG} = 1 ]
then
        EXCEP00CSV=${OUTFILE}
else
        EXCEP00CSV=/usr/lnk/tmp/EXCEP00CSV.txt
fi
export EXCEP00CSV

FG4AUD=$FG4AUD
  export FG4AUD


echo "Exception Master (EXCEP00MAS) Update"
date
echo "EXPORT PATHS:"
echo "   EXCEP00MAS=${EXCEP00MAS}"
echo "   EXCEP00CSV=${EXCEP00CSV}"
echo "   FG4AUD=${FG4AUD}"
echo "   PARMFILE=${PARMFILE}"

submit_excepup001
date

exit $RETVAL
