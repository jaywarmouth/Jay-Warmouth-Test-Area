#!/bin/sh
#
# Program Name	:claim136.lc 
# Description   : INITIALIZE SELECT CLAIM MASTER FILE RECORDS
#                 Command line arguments
#                 -i <filename> - assign alternate input file
#		  -o <filename> - assign alternate output/results file
#		  -f <filename> - assign alternate CLAIM00MAS file

#                 Switches:
#                 -t Test mode (no CLAIM00MAS file writes)

# Author	: Lucy A. Caraballo 
# Date		: 5/01/2015
# Modifications : 05/18/2015 - Changes for production version (LSJ)
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILEDIR=/usr/lnk/tmp
IN_FLAG=0
OUT_FLAG=0
FILE_FLAG=0
TEST_MODE=0
DATETM=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim136.lc [-i <filename>][-o <filename>] [-f <filename>] [-t]
	-i <filename> is optional to provide input PARAMFILE filename
	-o <filename> option for CLAIM136CSV output filename
	-f <filename> optional for alternate CLAIM00MAS filename

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

	
# Submit claim136 program
submit_claim136()
{
      runcobol ${OBJ_DIR}/claim136 -s ${TEST_MODE} 
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
	IN_FLAG=1
	IN_FILE=$1
	;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	OUT_FLAG=1
	OUT_FILE=$1
	;;
    -f) shift
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

if [ $IN_FLAG = 1 ]
then
	PARMFILE=$IN_FILE
else
	PARMFILE=/usr/lnk/tmp/PARMFILE-CLAIM136.txt
fi
if [ $OUT_FLAG = 1 ]
then
	CLAIM136CSV=$OUT_FILE
else
	CLAIM136CSV=/usr/lnk/tmp/CLAIM136CSV-${DATETM}.txt
fi
if [ $FILE_FLAG = 1 ]
then
	CLAIM00MAS=$FILE
	export CLAIM00MAS
fi

export PARMFILE CLAIM136CSV
         
FG4AUD=/usr/lnk/audit/CLAIM02
   export FG4AUD

   echo "INITIALIZE OOP AMOUNT ON CLAIMS MASTER FILE TO ZERO"
   date
   echo "EXPORT PATHS:"
   echo "   CLAIM00MAS=$CLAIM00MAS"
   echo "   PARMFILE=$PARMFILE"
   echo "   CLAIM136CSV=$CLAIM136CSV"
   echo "   FG4AUD=${FG4AUD}" 
   submit_claim136
   date

exit 0
