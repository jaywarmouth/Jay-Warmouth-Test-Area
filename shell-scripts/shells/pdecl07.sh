#!/bin/ksh
#
# to run: pdecl07.sh if <assign REJECTCODES> -t 
#
# Program Name	: pdecl07.sh   
# Description   : Automated PDE resubmission  
#                 Command line arguments:
#                   none 
#                 Switches:
#                 -t Test Mode - PDECL00MAS and FG4AUD are not updated 
#		  -f <input filename>
# Author	: Peggy Voytilla
# Date		: 12/12/2012
# Modifications : 01/09/2013 - add '-f' argument
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RUN="/usr/rmcobol/terminfo-d0.cfg"
TEST_MODE=0
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl07.sh -f <input file> -t
	-f <input file>	 (required) - assigns REJECTCODES
	-t for test-mode (optional)

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

	
#
# Main routine
#
#Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
        usage
fi
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	REJECTCODES=$1
	export REJECTCODES
	;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

FG4AUD=/usr/lnk/audit/PDEAUD
 export FG4AUD

if [ $TEST_MODE = 1 ]
then
	REPORTFILE=/usr/lnk/tmp/PDECL07-REPORT-TEST.csv
	export REPORTFILE
else
	REPORTFILE=/usr/lnk/tmp/PDECL07-REPORT-${DATE}.csv
	export REPORTFILE
fi

if ! test -e ${REJECTCODES}
then
	echo "The assigned input file, ${REJECTCODES}, doesn't exist."
	echo "Process stopped..."
	exit 1
fi

date
echo "AUTOMATED PDE RESUBMISSION:"
echo "   FG4AUD=$FG4AUD"
echo "   PDECL00MAS=$PDECL00MAS"
echo "   REPORTFILE=$REPORTFILE"
echo "   REJECTCODES=$REJECTCODES"
echo "      `cat $REJECTCODES`"

runcobol ${OBJ_DIR}/pdecl07 -s ${TEST_MODE}

date

exit 0
