#!/bin/ksh
#
# to run: convrev.vr -f /usr/lnk/claims/REVER00MAS -n /usr/lnk/d0/REVERD0MAS
#
# Program Name	: convrev.sh 
# Description   : Conversion Process For REVER00MAS.
#                 Command line arguments:
#		  -f <filename> - path and filename of reversal file
#		  -n <filename> - path and filename of new reversal file
# Author	: Vito Restaino
# Date		: 02/25/2011
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE="null"
NEW_FILE="null"
RUN="/usr/rmcobol/terminfo-d0.cfg"
#HOSTNAME=`/usr/ucb/hostname`
SEL_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convrev.sh [-f <filename>] [-n <filename>]

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

	
# Submit convrev program
submit_convrev()
    runcobol ${OBJ_DIR}/convrevd0 -C ${RUN}

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
  REVER00OLD=${FILE}
  export REVER00OLD
fi
if [ ${NEW_FILE} = "null" ]
then
  usage
else
  REVERD0MAS=${NEW_FILE}
  export REVERD0MAS
fi


echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   REVER00OLD=$REVER00OLD"
echo "   REVERD0MAS=$REVERD0MAS"
submit_convrev
date

exit 0
