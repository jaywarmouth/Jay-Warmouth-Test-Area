#!/bin/ksh
#
# to run: restack05.sh -f <assign RESTACKRS> -t 
#
# Program Name	: restack05.sh
# Description   : Reverse Reset of pde send ind and date for restacked claims
#                 using RESTACKRS reverse file created by restack04
#                 this step not a regular part of the restack process unless reversal
#                 of restack04 is needed
#                 Switches:
#                 -t Test Mode - PDECLM00MAS is not updated 

# Author	: Joe Novicky # Date		: 11/27/2013

# Modifications : 
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
DATE=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack05.sh -f <input file> -t
        -f <input file>  (required) - assigns RESTACKRS
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
        RESTACKRS=$1
        export RESTACKRS
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env
    

if [ $TEST_MODE = 1 ]
then
        RESTACKRPT=/usr/lnk/tmp/RESTACK05-RESTACKRPT-TEST.txt
        export RESTACKRPT
else
        RESTACKRPT=/usr/lnk/tmp/RESTACK05-RESTACKRPT-${DATE}.txt
        export RESTACKRPT
fi

if ! test -e ${RESTACKRS} 
then
        echo "The assigned input file, ${RESTACKRS}, doesn't exist."
        echo "Process stopped..."
        exit 1
fi


date
echo "RESTACK05 REVERSE RESTACK04 RESET PDE SENT IND AND DATE "
echo "   FG4AUD=$FG4AUD"
echo "   PDECL00MAS=$PDECL00MAS"
echo "   RESTACKRPT=$RESTACKRPT"
echo "   RESTACKRS=$RESTACKRS"

runcobol ${OBJ_DIR}/restack05 -s ${TEST_MODE}
date


exit 0
