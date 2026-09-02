#!/bin/sh
#
# Program Name	: accum01sp.sh - accum01 split

#                 Command line arguments:
#                 
#                 
# Author	: Marty Urbanek
# Date		: 11/29/2018
# Modifications : 05/18/2022 - add logic to check if input file exists and if not provide message and exit. 
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: accum01sp.sh InputAccumFile InputConfigFile ReportFile

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
# Check command line validity, call usage if incorrect
ACCUMIN=$1
CONFIGIN=$2
RUNRPT=$3

if test ! -s ${ACCUMIN}
then 
	echo "Input file does not exist or is empty"
	echo "Input File: ${ACCUMIN}"
	exit 99
fi

# Parse environment variables
parse_env

# Assign alternate environment variables
ACCUM01IN=${ACCUMIN}   
export ACCUM01IN 

REPORTFILE=${RUNRPT}
export REPORTFILE

PATHTABLE=${CONFIGIN}
export PATHTABLE

date
echo "EXPORT PATHS:"
echo "   ACCUM01IN=$ACCUM01IN "
echo "   REPORTFILE=$REPORTFILE "
echo "   PATHTABLE=$PATHTABLE "

runcobol ${OBJ_DIR}/accum01sp
RETVAL=$?

echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
