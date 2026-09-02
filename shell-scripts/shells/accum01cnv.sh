#!/bin/sh
#
# Program Name	: accum01cnv.sh 
#		  Command Line argument:
#		  -i <accum filename> - e.g sil0327		
# Description   : Line by line copy of accum01 file.
#                 
#                 
# Author	: Dave Rudawsky
# Date		: 12/23/2014
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE="null"
DIR="/usr/lnk/elig_in"
OBJ_DIR="/usr/lnk/obj"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: accum01cnv.sh -i <??lmmdd>

ENDOFUSAGE
  exit 99
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

	
# Submit accum01cnv program
submit_accum01cnv()
{
      runcobol ${OBJ_DIR}/accum01cnv 
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
fi

 ACCUM01INP=$DIR/$FILE
  export ACCUM01INP
 ACCUM01TAP=$DIR/$FILE.lin
  export ACCUM01TAP

echo CONVERT ACCUM01 INPUT FILE
date
echo "EXPORT PATHS:"
echo "   ACCUM01INP=$ACCUM01INP"
echo "   ACCUM01TAP=$ACCUM01TAP"

if test -s ${ACCUM01INP}
then
	submit_accum01cnv
else
	echo ""
	echo "**> ERROR **"
	echo "**> The input file, ${ACCUM01INP}, does not exist, check command line **"
	echo ""
	exit 99
fi
date

exit $RETVAL
