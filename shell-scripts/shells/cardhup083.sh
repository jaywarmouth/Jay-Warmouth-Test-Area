#!/bin/sh
#
# Program Name	:cardhup083.lc 
# Description   : Update GROUP MOVES BASED ON CARD NUM ALT ID - INPUT PARAMETERS
#                 Command line arguments:
#                 -i <param filename> 
#			Default is: 
#                 Switches:
#                 -t Test mode (no CARDH00MAS file rewrites)
#
# Author	: Lucy A. Caraballo 
# Date		: 1/12/2015
# Modifications : 2/26/2015 - Updates for production (LSJ) 
#		: 03/04/2015 - Fixed FILEDIR assignment  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILEDIR=/usr/lnk/wt/oper-wt/misc
FILE_FLAG=0
TEST_MODE=0
DATETM=`date +%Y%m%d-%H%M%S`
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhup083.lc [-i <filename>] [-t]
	-i <param filename> is optional 

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

	
# Submit cardhup083 program
submit_cardhup083()
{
      runcobol ${OBJ_DIR}/cardhup083 -s ${TEST_MODE}  
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

         
FG4AUD=/usr/lnk/audit/CRDAUD-FG
   export FG4AUD
  
CARD083CSV=${FILEDIR}/CARD083CSV-${DATETM}.txt
   export CARD083CSV

if [ ${FILE_FLAG} = 1 ]
then
	PARMFILE=$FILE
else
	PARMFILE=/usr/lnk/wt/oper-wt/CARD083-PARMFILE.txt
fi
export PARMFILE

   echo "Update GROUPS TERMINATIONS BASED ON ALTERNATE CARD ID"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   CARDH00MAS=$CARDH00MAS"
   echo "   PARMFILE=$PARMFILE"
   echo "   CARD083CSV=$CARD083CSV" 
   submit_cardhup083
   date

exit 0
