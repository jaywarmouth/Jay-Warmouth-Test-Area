#!/bin/sh
#
# Program Name	: cardhupdt01.sh
# Description   : update the CARDH00MAS file from input file
#                 Command Line Arguments: None
#                 -t TEST MODE  
#                 
# Author	: Greg Vernon  
# Date		: 10/08/2020
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
TEST_MODE=0
INFILE_FLG=0
OUTFILE_FLG=0
CRDFILE_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardupdt01.sh -t -f <alt cardh file> -i <input file> -o <output errorfile>

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


# Submit cardhupdt01  program
submit_cardhupdt01()
{
     runcobol ${OBJ_DIR}/CARDHUPDT01 -a ${TEST_MODE}
	RETVAL=$?
}
# Main routine#
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
        CRDFILE_FLG=1
        CRDFILE=$1
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
  esac
  shift
done
 
# Parse environment variables
parse_env



# Assign alternate environment variables
  
if [ $INFILE_FLG = 1 ]
then
        TRANSIN=${INFILE}
else
        usage
fi

if [ $CRDFILE_FLG = 1 ]
then
        CARDH00MAS=${CRDFILE}
        export CARDH00MAS
fi

if [ $OUTFILE_FLG = 1 ]
then
        UPDTERROR=${OUTFILE}
else
        UPDTERROR=/usr/lnk/wt/oper-wt/misc/cardhupdt01-UPDTERROR.csv
fi

export TRANSIN UPDTERROR

AUDIT20MAS=/usr/lnk/audit/CRDAUD
export AUDIT20MAS

echo "UPDATE CARDH00MAS FILE"


date

echo "CARDH00MAS=${CARDH00MAS}"
echo "TRANSIN=${TRANSIN}"
echo "UPDTERROR=${UPDTERROR}"
echo "AUDIT20MAS=${AUDIT20MAS}"

submit_cardhupdt01

echo "RET_CODE=$RETVAL"

date

exit $RETVAL
