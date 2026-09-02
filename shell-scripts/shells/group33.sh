#!/bin/sh
#
# Program Name	:group33.sh 
# Description   : Create new GROUP STRUCTURES USING INPUT PARAMETERS
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no GROUP00MAS file rewrites)
#		  -f <input file> - optional, default is /usr/lnk/tmp/GROUP33-PARMFILE.txt
#		  -o <output GROUP33CCSV> - optional, default is /usr/lnk/tmp/GROUP33CAV.txt
# Author	: Lucy A. Caraballo 
# Date		: 8/05/2015
# Modifications : 08/11/2015 - updates for production version
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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group33.sh -t -f <input PARMFILE> -o <output GROUP33CSV file>

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

	
# Submit group31 program
submit_group33()
{
      runcobol ${OBJ_DIR}/group33 -s ${TEST_MODE} 
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
	PARMFILE=/usr/lnk/tmp/GROUP33-PARMFILE.txt
fi
export PARMFILE

if [ ${OUTFILE_FLG} = 1 ]
then
	GROUP33CSV=${OUTFILE}
else
	GROUP33CSV=/usr/lnk/wt/oper-wt/GROUP33CSV.csv
fi
export GROUP33CSV

FG4AUD=${GRPAUD}
  export FG4AUD
         

echo "UPDATE GROUP00MAS FILE BASED OFF INPUT FILE"

date
echo "EXPORT PATHS:"
echo "   FG4AUD=${FG4AUD}"
echo "   GROUP00MAS=$GROUP00MAS"
echo "   PARMFILE=$PARMFILE"
echo "   GROUP33CSV=$GROUP33CSV" 

submit_group33

date

exit 0
