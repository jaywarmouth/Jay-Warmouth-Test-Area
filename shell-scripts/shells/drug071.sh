#!/bin/sh
# To run: drug071.sh -t -i /usr/lnk/wrk/DRGWRKMAS-LC
#
# Program Name	: drug071.sh 
# Description   : Update LITIGATION FLAG
#                 Command line arguments
#                 -i <filename> - assign alternate input file

#                 Switches:
#                 -t Test mode (no DRUGMAS file rewrites)

# Author	: Lucy A. Caraballo 
# Date		: 11/10/2014
# Modifications :  
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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug071.sh [-i <filename>] [-t]
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

	
# Submit drug071 program
submit_drug071()
{
      runcobol ${OBJ_DIR}/drug071 -s ${TEST_MODE} 
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
	DRUGWRKMAS=$FILE
else
   DRUGWRKMAS=/usr/lnk/drug/DRUGAWPLITMAS
fi
   export DRUGWRKMAS
         
DRUG071CSV=/usr/lnk/misc/DRUG071.csv
   export DRUG071CSV


   echo "Update LITIGATION FLAG from DRUG MASTER file"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   DRUG000MAS=$DRUG000MAS"
   echo "   DRUGWRKMAS=$DRUGWRKMAS"
   echo "   DRUG071CSV=$DRUG071CSV" 
   submit_drug071
   date

exit 0
