#!/bin/ksh
#
# to run: limit50.sh -t
#
# Program Name	: limit50.sh 
# Description   : Update Limit Master with amounts over contracted rate (update ADD-TO-TROOP)
#                 Command line arguments:
#                    none
#                 Switches:
#                 -t Test Mode - LIMIT00MAS and FG4AUD are not updated 
#		  -i <input file> - assign INPUTTRAN file

# Author	: Peggy Voytilla
# Date		: 10/09/2012
# Modifications : 11/08/2012 - ljefferis - added "i" option 
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
INPUTTRAN="null"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit50.sh 

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

	
# Submit limit50 program
submit_limit50()
{
      runcobol ${OBJ_DIR}/limit50 -s ${TEST_MODE} 
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	INPUTTRAN=$1
	export INPUTTRAN
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

FG4AUD=/usr/lnk/audit/LIMAUD
 export FG4AUD

if [ $TEST_MODE = 1 ]
then
	OUTPUTMSG=/usr/lnk/tmp/LIMIT50-MESSAGE-TEST.csv
	export OUTPUTMSG
else
	OUTPUTMSG=/usr/lnk/tmp/LIMIT50-MESSAGE-${DATE}.csv
	export OUTPUTMSG
fi

date
echo "LIMIT50 EXPORT PATHS:"
echo "   INPUTTRAN=$INPUTTRAN"
echo "   LIMIT00MAS=$LIMIT00MAS"
echo "   FG4AUD=$FG4AUD"
echo "   OUTPUTMSG=$OUTPUTMSG"
submit_limit50
date


exit 0
