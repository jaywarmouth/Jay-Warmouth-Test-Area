#!/bin/sh
#
# Program Name	: pndesup01.sh
# Description   : Update PNDES00MAS using update parameters         
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no PNDES00MAS file rewrites)
#		  -f <input file> - optional, default is /usr/lnk/tmp/PARMFILE-PNDES.txt
#		  -o <output PNDES00CSV> - optional, default is /usr/lnk/tmp/PNDES00CSV.txt
# Author	: John Shrigley     
# Date		: 2/15/2016
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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pndesup01.sh -t -f <input PARMFILE> -o <output PNDES00CSV file>

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

	
# Submit pndesup01 program
submit_pndesup01()
{
      runcobol ${OBJ_DIR}/pndesup01 -s ${TEST_MODE} 
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
	PARMFILE=/usr/lnk/tmp/PARMFILE-PNDES.txt
fi
export PARMFILE

if [ ${OUTFILE_FLG} = 1 ]
then
	PNDES00CSV=${OUTFILE}
else
	PNDES00CSV=/usr/lnk/tmp/PNDES00CSV.txt
fi
export PNDES00CSV

FG4AUD=${PHAAUD}
  export FG4AUD


echo "UPDATE PNDES00MAS FILE BASED OFF INPUT FILE"

date
echo "EXPORT PATHS:"
echo "   FG4AUD=${FG4AUD}"
echo "   PNDES00MAS=$PNDES00MAS"
echo "   PARMFILE=$PARMFILE"
echo "   PNDES00CSV=$PNDES00CSV" 

submit_pndesup01

date

exit $RETVAL
