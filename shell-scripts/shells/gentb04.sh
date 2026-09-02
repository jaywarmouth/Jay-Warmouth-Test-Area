#!/bin/sh
#
# Program Name	:gentb04.sh 
# Description   : Update GENERIC TABLE GPI'S BASED ON USER INPUT PARAMETERS
#                 Command line arguments
#                 -i <filename> - assign alternate input file
#		  -o <filename> - assign alternate GENTB04CSV output filename

#                 Switches:
#                 -t Test mode (no GENTB00MAS file writes)

# Author	: Lucy A. Caraballo 
# Date		: 2/18/2015
# Modifications : 3/18/2015 - Updates for production version 
#		: 03/26/2015 - Cleanup modifications
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
FILEDIR=/usr/lnk/tmp
FILE_FLAG=0
OUTFILEFLG=0
TEST_MODE=0
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gentb04.lc [-i <filename>] [-t]
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

	
# Submit gentb04 program
submit_gentb04()
{
      runcobol ${OBJ_DIR}/gentb04 -s ${TEST_MODE} 
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
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	OUTFILEFLG=1
	OUTFILE=$1
	;;
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

# Assign other program files
if [ $FILE_FLAG = 1 ]
then
	PARMFILE=$FILE
else
	PARMFILE=/usr/lnk/wt/benefit-wt/GenericTableUpdates/GTupdate_Input.txt
fi
export PARMFILE

if [ $OUTFILEFLG = 1 ]
then
	GENTB04CSV=$OUTFILE
else
	GENTB04CSV=/usr/lnk/wt/benefit-wt/GenericTableUpdates/GENTB04-${DATETM}.csv	
fi
export GENTB04CSV


   echo "Update GENERIC TABLE MASTER FILE WITH NEW GPI'S"
   date
   echo "EXPORT PATHS:"
   echo "   GENTB00MAS=$GENTB00MAS"
   echo "   GENER00MAS=$GENER00MAS"
   echo "   PARMFILE=$PARMFILE"
   echo "   GENTB04CSV=$GENTB04CSV" 
   submit_gentb04
   date

exit $RETVAL
