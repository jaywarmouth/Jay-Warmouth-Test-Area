#!/bin/sh
#
# Program Name	: accum02.sh 
# Description   : Validate input accum01 file from received from client. Pass valid file to accum01 program
#                   or set condition code 99 and send error report to client.
#                 Command line arguments: 
#                 -i <input file> - e.g. sil0327.lin 
#                 
# Author	: Dave Rudawsky
# Date		: 03/27/2015
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE="null"
DIR="/usr/lnk/elig_in"
DATETM=`date +%Y%m%d%-H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: accum02.dr

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

	
# Submit accum02 program
submit_accum02()
{
      runcobol ${OBJ_DIR}/accum02 
	RETVAL="$?"
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
        FILE=$1
        ;;
  esac
  shift
done
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $FILE = "null" ]
then
	usage
	exit 1
fi
ACCUM01TAP=$DIR/$FILE
export ACCUM01TAP

ERRORRPT=/usr/lnk/elig_out/ACCUM02-ERROR-$FILE-${DATETM}.txt
export ERRORRPT


echo VALIDATE ACCUM01 INPUT FILE
date
echo "EXPORT PATHS:"
echo "   ACCUM01TAP=$ACCUM01TAP"
echo "   ERRORRPT=$ERRORRPT"

submit_accum02
date


exit $RETVAL
