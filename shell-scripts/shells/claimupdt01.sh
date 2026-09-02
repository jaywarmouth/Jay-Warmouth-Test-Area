#!/bin/sh
#
#
# Program Name	: claimupdt01.sh
# Description   : update the CLAIM00MAS file from input file
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
CLMFILE_FLG=0
AUDFILE_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claimupdt01.sh [-t] -f <alt claim file> -i <input file> -o <output errorfile> -a <alt AUDIT file>

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


# Submit CLAIMUPDT01  program
submit_claimupdt01()
{
     runcobol ${OBJ_DIR}/CLAIMUPDT01 -a ${TEST_MODE}
	RETVAL=$?
}
# Main routine#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLMFILE_FLG=1
        CLMFILE=$1
        ;;
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        AUDFILE_FLG=1
        AUDFILE=$1
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
    -t) TEST_MODE=1
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

if [ $CLMFILE_FLG = 1 ]
then
	CLAIM00MAS=${CLMFILE}
	export CLAIM00MAS
fi

if [ $OUTFILE_FLG = 1 ]
then
	UPDTERROR=${OUTFILE}
else
	UPDTERROR=/usr/lnk/wt/oper-wt/misc/claimupdt01-UPDTERROR.csv
fi
 
export TRANSIN UPDTERROR

if [ $AUDFILE_FLG = 1 ]
then
	AUDIT20MAS=${AUDFILE}
	export AUDIT20MAS
else
	AUDIT20MAS=/usr/lnk/audit/CLAIM02-claimupdt01
fi
export AUDIT20MAS

if ! test -e ${AUDIT20MAS}
then
	touch ${AUDIT20MAS}; chmod 666 ${AUDIT20MAS}
fi

echo "UPDATE Claims OtherPayerCoverageType "

date

echo "CLAIM00MAS=${CLAIM00MAS}"
echo "TRANSIN=${TRANSIN}"
echo "UPDTERROR=${UPDTERROR}"
echo "AUDIT20MAS=${AUDIT20MAS}"

submit_claimupdt01

date
echo "RETURN_CODE=${RETVAL}"

exit ${RETVAL}
