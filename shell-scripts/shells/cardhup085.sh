#!/bin/sh
#
# Program Name	:cardhup085.sh
# Description   : Update CARDHOLDER using update parameters         
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no CARDH00MAS file rewrites)
#		  -f <input file> - required
#		  -o <output CARDH85CSV> - optional, default is /usr/lnk/wt/oper-wt/CARDH85CSV.csv
# Author	: John Shrigley     
# Date		: 1/19/2016
# Modifications :                                               
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
OUTFILE_FLG=0
TEST_MODE=0
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhup085.sh -t -f <input PARMFILE> -o <output CARDH85CSV file>

ENDOFUSAGE
  exit 1
}


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

	
# Submit cardhp085 program
submit_cardhup085()
{
      runcobol ${OBJ_DIR}/cardhup085 -s ${TEST_MODE} 
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
    -t) TEST_MODE=1
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
	usage
fi
export PARMFILE

if [ ${OUTFILE_FLG} = 1 ]
then
	CARDH85CSV=${OUTFILE}
else
	CARDH85CSV=/usr/lnk/wt/oper-wt/CARDH85CSV-${DATETM}.csv
fi
export CARDH85CSV

FG4AUD=${CRDAUD}
  export FG4AUD


echo "UPDATE CARDH00MAS FILE BASED OFF INPUT FILE"

date
echo "EXPORT PATHS:"
echo "   FG4AUD=${FG4AUD}"
echo "   CARDH00MAS=$CARDH00MAS"
echo "   PARMFILE=$PARMFILE"
echo "   CARDH85CSV=$CARDH85CSV" 

submit_cardhup085

date

exit ${RETVAL}
