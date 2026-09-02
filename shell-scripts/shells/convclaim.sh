#!/bin/ksh
#
# Program Name	: convclaim.sh 
# Description   : Conversion Process For CLAIM00MAS.
#                 Command line arguments:
#		  -f <filename> - path and filename of claims file
#		  -n <filename> - path and filename of new converted claims file
#		  -b <batch range> - allows specific batch range of a file to be converted instead of the whole file.
# Author	: Dave Tucci
# Date		: 01/27/99
# Modifications : 03/30/99 - Added command line arguments and associated logic  (LSJ)
#		: 10/07/99 - Added "batch range" option  (LSJ)
#		: 10/07/99 - Added set_run procedure  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE="null"
NEW_FILE="null"
RUN=""
HOSTNAME=`/usr/ucb/hostname`
SEL_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convclaim.sh [-f <filename>] [-n <filename>]

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
# Set run configuration
set_run()
{
   case ${HOSTNAME} in
     "pdm01")
	RUN="C=/usr/local/rmcobol/spec.cfg"
	;;
     "raven" | "falcon" | "pdm00")
	RUN="C=/usr/rmcobol/spec.cfg"
	;;
   esac
}

	
# Submit convclaim program
submit_convclaim()
{
   if [ ${SEL_RUN} = 1 ]
   then
      runcobol ${OBJ_DIR}/convclaim ${RUN} -s ${SEL_RUN} -a ${BATCH}
   else
      runcobol ${OBJ_DIR}/convclaim ${RUN} -s ${SEL_RUN}
   fi
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
	FILE=$1
	;;
    -n) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	NEW_FILE=$1
	;;
    -b) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	BATCH=$1
	SEL_RUN=1
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
  CLAIM00OLD=${FILE}
  export CLAIM00OLD
fi
if [ ${NEW_FILE} = "null" ]
then
  usage
else
  CLAIM00MAS=${NEW_FILE}
  export CLAIM00MAS
fi

set_run

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   CLAIM00OLD=$CLAIM00OLD"
echo "   CLAIM00MAS=$CLAIM00MAS"
submit_convclaim
date

chmod 664 ${CLAIM00OLD}
chmod 664 ${CLAIM00MAS}

exit 0
