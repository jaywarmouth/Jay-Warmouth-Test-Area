#!/bin/sh
#
# Program Name	:gentb05.sh 
# Description   : Update GENERIC TABLE GPI'S BASED ON USER INPUT PARAMETERS
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no GENTB00MAS file rewrites)
#                 -i <filename> - assign alternate input PARMFILE file
# Author	: Lucy A. Caraballo 
# Date		: 3/03/2015
# Modifications : 09/15/2015 - Updates for production version 
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
TEST_MODE=0
DATETM=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gentb05.lc [-t]

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

	
# Submit gentb05 program
#  To run shell in debug mode add D to end of runcobol statement below 
submit_gentb05()
{
      runcobol ${OBJ_DIR}/gentb05 -s ${TEST_MODE} 
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

FG4AUD=$FG4AUD
  export FG4AUD
           
if [ $FILE_FLAG = 1 ]
then
	PARMFILE=$FILE
else
	PARMFILE=/usr/lnk/tmp/PARMFILE-GENTB05.txt
fi
export PARMFILE

GENTB05CSV=/usr/lnk/wt/benefit-wt/GenericTableUpdates/GENTB05CSV-${DATETM}.csv
   export GENTB05CSV


   echo "Move OLD GPI to NEW GPI in GENTB00MAS FILE"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   GENTB00MAS=$GENTB00MAS"
   echo "   GENER00MAS=$GENER00MAS"
   echo "   PARMFILE=$PARMFILE"
   echo "   GENTB05CSV=$GENTB05CSV" 
   submit_gentb05
   date

exit 0
