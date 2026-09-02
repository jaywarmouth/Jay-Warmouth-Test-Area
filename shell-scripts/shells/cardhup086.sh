#!/bin/sh
# To run: cardhup086.lc -b 0073 (First Run - SYSTEM 73)
#         cardhup086.lc -b 0158 (2nd Run - SYSTEM 158    
#
# Program Name	:cardhup086.sh 
# Description   : Update MEDICAL ID NUMBER FOR SYSTEMS 73 & 158 CARDHOLDERS     #                 not Sponsor 366
#     
#                 Command line arguments
#                 -b <system number> - run for specific system number
#
#                 Switches:
#                 -t Test mode (no CATAB00MAS file rewrites)
#
# Author	: Lucy A. Caraballo 
# Date		: 1/20/2016
# Modifications : 2/2/2016 - updates for production version (LSJ) 
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
SYSTEM_NUMBER="null"
RETVAL=0
DATETM=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhup086.sh [-t TEST_MODE] [-b <system number>]

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

	
# Submit cardhup086 program
submit_cardhup086()
{
      runcobol ${OBJ_DIR}/cardhup086 -a ${SYSTEM_NUMBER}
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
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYSTEM_NUMBER=$1
        ;;
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

FG4AUD=$CRDAUDFG
   export FG4AUD
  
CARD086CSV=/usr/lnk/tmp/CARD086CSV-${DATETM}.txt
   export CARD086CSV



   echo "Update MEDICAL ID NUMBERS FOR INPUT SYSTEM NUMBER"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   CARDH00MAS=$CARDH00MAS"
   echo "   CATAB00MAS=$CATAB00MAS"
   echo "   GROUP00MAS=$GROUP00MAS"
   echo "   SPONS00MAS=$SPONS00MAS"
   echo "   SITE000MAS=$SITE000MAS"
   echo "   CARD086CSV=$CARD086CSV" 
   submit_cardhup086
   date

exit $RETVAL
