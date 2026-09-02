#!/bin/ksh
#       
#
# Program Name	: pdecl05.sh
# Description   : PDE File Creation
#                 Command line arguments:
#                 -f input file name 
#                 -t test mode
# Author	: Peggy Voytilla
# Date		: 10/04/2011
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE="null"
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl05.sh [-t] [-f <input-file>]
	-t	no update of PDECL00MAS
	<input file> - /usr/lnk/pde/in/RPT.DDPS_TRANS_VALIDATION.<????????>


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


# Submit pdecl05 program
submit_pdecl05()
{
     runcobol ${OBJ_DIR}/pdecl05 -s ${TEST_MODE} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
        usage
        exit 1
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
        FILE=$1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE} = "null" ]
then
  usage
else
 PDERETURN=${FILE}
    export PDERETURN
fi

if [ ${TEST_MODE} = 1 ]
then
	RPT_DIR=/usr/lnk/wrk
else
	RPT_DIR=/usr/lnk/misc
fi

FG4AUD=/usr/lnk/audit/PDEAUD
export FG4AUD

echo "PDE Return File Update - pdecl05"
date
echo "EXPORT PATH:"
echo "   PDERETURN=$PDERETURN"
echo "   RPT_DIR=$RPT_DIR"

submit_pdecl05 

echo "--> The file size of the following report(s) should be zero"
echo "--> If not zero, stop further processing of file and"
echo "      provide report to PartD Prgrammers for review."
ls -l ${RPT_DIR}/PDECL05-REPORT-*

date

exit 0
