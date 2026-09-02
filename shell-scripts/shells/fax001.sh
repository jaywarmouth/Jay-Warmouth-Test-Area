#!/bin/ksh
#
# Program Name	: fax001.sh
# Description	: Fax Routine
#                 Command Line Arguments:
#                 -s Skip sort flag
#                 -r <ccyymmdd> - Date of daily rerun to be run)
#                 -m <sys#-####><batch range> - Month Run 
# Author	: Linda S. Jefferis
# Date		: 05/14/98
# Modifications : 05/28/99 - Added century to input date (LSJ)
#		  04/23/2001 - Added logic for new Month Run  (LSJ)
#		: 08/22/2006 - Changes for 4-digit system number  (LSJ)
#		: 10/09/2006 - Added -follow to find commands  (LSJ)
#		: 10/13/2006 - Changed rm to rm -f  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FAX_DIR=/usr/pdm/fax
SKIP_SORT=0
ARGUMENT="00000000"
MONTH_RUN=0
SYS=0000
BATCH_RANGE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: fax001.sh [-s] [-r <ccyymmdd>] [-m <#### - sys#><batch range>]

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit fax001 program
submit_fax001()
{
      runcobol ${OBJ_DIR}/fax001 -s ${SKIP_SORT}${MONTH_RUN} -a ${ARGUMENT}${SYS}${BATCH_RANGE}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1
        ARGUMENT=$1
        ;;
    -m) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	MONTH_RUN=1
	SYS=`echo $1 | cut -c1-4`
	BATCH_RANGE=`echo $1 | cut -c5-20`
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

cd ${FAX_DIR}
if [ ${MONTH_RUN} = 1 ]
then
   echo "Monthly Fax Report"
   date
   find ${SYS} -follow -name "??FXMO.FAX" -exec rm -f {} \;
   echo "INPUT VARIABLES:"
   echo "   SYSTEM = ${SYS}"
   echo "   BATCH RANGE = ${BATCH_RANGE}"
else
   echo "Daily Fax Report"
   date
   find sys???? -follow -name "???FX00.FAX" -exec rm -f {} \;
fi

submit_fax001

date

exit 0
