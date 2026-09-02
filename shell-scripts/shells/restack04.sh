#!/bin/ksh
#
# to run: restack04.sh -f <assign RESTACK> -t 
#
# Program Name	: restack04.sh 
# Description   : Reset pde send ind and date for restacked claims 
#                 Command line arguments:

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

usage: restack04.sh -f <input file> -t
        -f <input file>  (required) - assigns RESTACK
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
        RESTACK=$1
        export RESTACK
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
        RESTACKRS=/usr/lnk/tmp/RESTACK04-RESTACKRS-TEST.txt
        export RESTACKRS
else
        RESTACKRS=/usr/lnk/tmp/RESTACK04-RESTACKRS-${DATE}.txt
        export RESTACKRS
fi

if ! test -e ${RESTACK}
then
        echo "The assigned input file, ${RESTACK}, doesn't exist."
        echo "Process stopped..."
        exit 1
fi




date
echo "RESTACK RESET PDE SENT IND AND DATE "
echo "   FG4AUD=$FG4AUD"
echo "   PDECL00MAS=$PDECL00MAS"
echo "   RESTACK=$RESTACK"
echo "   RESTACKRS=$RESTACKRS"

runcobol ${OBJ_DIR}/restack04 -s ${TEST_MODE}
date


exit 0
