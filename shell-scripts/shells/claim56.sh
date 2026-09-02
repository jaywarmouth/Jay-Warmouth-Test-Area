#!/bin/sh
#
# Program Name	: claim56.sh 
# Description   : CLAIM55MAS PC EXTRACT FILE SENT FOR WAREHOUSE
#                 Command line arguments:
#                 -t TEST MODE
#		  -i <CLAIM55MAS file>
#		  -o <CLAIM55CSV file>                 
#		  -d <ccyyccyy> - alternate date range; default is previous year thru current year.
# Author	: Lucy A. Caraballo
# Date		: 12/23/2014  
# Modifications : 01/06/2015 Updates for production.           
#		: 03/01/2023 Added INFLG/OUTFLG logic
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_NAME="null"
TEST_MODE=0
PREVYR=`date -d "last year" +%Y`
CURRYR=`date +%Y`
DATEFLG=0 
INFLG=0
OUTFLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim56.sh [-t] -i <CLAIM55MAS> -o <CLAIM55CSV> -d <ccyyccyy>

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

	
# Submit claim56 program             
     submit_claim56()
{
     runcobol ${OBJ_DIR}/claim56 -s ${TEST_MODE} -a ${YEARRGE}
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
	usage
	exit 1
fi
while [ $# -gt 0 ]
do
  case "$1"
  in 
    -t) TEST_MODE=1
        ;;
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	INFILE=$1
	INFLG=1
	;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	OUTFILE=$1
	OUTFLG=1
	;;
    -d) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	DATEFLG=1
	DATE=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

if [ $INFLG = 1 ]
then
	CLAIM55MAS=$INFILE; export CLAIM55MAS
fi
if [ $OUTFLG = 1 ]
then
	CLAIM55CSV=$OUTFILE; export CLAIM55CSV
fi
if [ $DATEFLG = 1 ]
then
	YEARRGE=$DATE
else
	YEARRGE=$PREVYR$CURRYR
fi

echo "CLAIM55MAS PC EXTRACT FILE"
date
echo "EXPORT PATHS:"
echo "   CLAIM55MAS=$CLAIM55MAS"
echo "   CLAIM55CSV=$CLAIM55CSV"
echo "   Extract Timeframe is:  $YEARRGE"

submit_claim56
date


exit 0
