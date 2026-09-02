#!/bin/sh
# To run: cardhup082.lc -t -i /usr/lnk/wrk/CARDH00MAS-SPO567
#                             /usr/lnk/wrk/CARDH00MAS-SPO601
#
# Program Name	:cardhup082.lc 
# Description   : Update ELIGIBILITY TERM DATE BASED ON SYSTEM/SPONSOR INPUT PARAMETERS
#                 Command line arguments
#                 -i <filename> - assign alternate input file

#                 Switches:
#                 -t Test mode (no CARDH00MAS file rewrites)

# Author	: Lucy A. Caraballo 
# Date		: 1/12/2015
# Modifications : 1/29/2016 Updates for production version 
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILEDIR=/usr/lnk/tmp
FILE_FLAG=0
TEST_MODE=0
DATETM=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhup082.lc [-i <filename>] [-t]
	-i <filename> is optional to provide input filename

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

	
# Submit cardhup082 program
submit_cardhup082()
{
      runcobol ${OBJ_DIR}/cardhup082 -s ${TEST_MODE} 
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
         
if [ $FILE_FLAG = 1 ]
then
	PARMFILE=$FILE
else
	PARMFILE=/usr/lnk/tmp/PARMFILE-CARD082.txt
fi
export PARMFILE

FG4AUD=${CRDAUD}
   export FG4AUD
  
CARD082CSV=/usr/lnk/tmp/CARD082CSV-${DATETM}.txt
   export CARD082CSV


   echo "Update ELIGIBILITY TERM DATE BY SYS/SPONSOR"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   CARDH00MAS=$CARDH00MAS"
   echo "   GROUP00MAS=$GROUP00MAS"
   echo "   PARMFILE=$PARMFILE"
   echo "   CARD082CSV=$CARD082CSV" 
   submit_cardhup082
   date

exit $RETVAL
