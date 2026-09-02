#!/bin/sh
#
# Program Name	:reimbrb02.sh 
# Description   : EXTRACT REIMB RECORDS BASED ON A PARAMETER FILE OR 
#                       RANGED PASSED WITH -a
#                 Command line arguments
#		  -a <range> - 0000#0000
#		  -f <REIMBPRM filename> - Flag for non-flexgen extract using 
#			designated REIMBPRM file.
#                 -t Test mode
# Author	: Debbe A. Adgate   
# Date		: 4/13/2016 
# Modifications : TT15456-3 - updates to all process to be run outside of Flexgen for export to warehouse.
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
RANGES="000000#000000"
DATETM=`date +%Y%m%d-%H%M%S`
SERVER=`/usr/lnk/shell/get_hostname.sh`
WHFLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: reimbrb02.sh -a <ranges>  -t

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

	
# Submit reimbrb02 program
submit_reimbrb02()
{
   if [ $WHFLAG = 0 ]
   then
	runcobol ${OBJ_DIR}/reimbrb02 -k -a ${RANGES}
   else
	runcobol ${OBJ_DIR}/reimbrb02
   fi
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
    -a) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	RANGES=$1
	;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        REIMBPRM=$1
	WHFLAG=1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

if [ $WHFLAG = 0 ]
then
	REIMBEXTR=/usr/lnk/wt/benefit-wt/reimbrb02_${RANGES}_${DATETM}.csv
else
	REIMBEXTR=/usr/lnk/sqlimports/misc/REIMBEXTR
	#REIMBPRM=/usr/lnk/log/REIMBPRM.txt; export REIMBPRM
fi
export REIMBEXTR REIMBPRM

   echo "REIMB00MAS RECS EXTRACTED  "
   date
   echo "EXPORT PATHS:"
   echo "   REIMB00MAS=$REIMB00MAS"
   echo "   REIMBPRM=$REIMBPRM"
   echo "   REIMBEXTR=$REIMBEXTR"
   submit_reimbrb02   
   date

exit ${RETVAL}
