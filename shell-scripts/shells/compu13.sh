#!/bin/ksh
#
# Program Name	: compu13.sh
# Description	: Opens and checks files indicated in VERIFYPRM parameter file.
#                 Command line arguments:
#                 -i input VERIFYFPRM parameter file name
#                 -o output VERIFYFLOG name
# Author	: Linda S. Jefferis
# Date		: 03/23/2017
# Modifications : 
#
# Variables Used:
PATH=$PATH:/opt/rmcobol
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
INFILE_FLG=0
OUTFILE_FLG=0
PARMDIR=/usr/lnk/log
OUTLOGDIR=/tmp
RETVAL=0
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: compu13.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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

#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        FILE_IN=$1
	INFILE_FLG=1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_OUT=$1
	OUTFILE_FLG=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

if [ $INFILE_FLG = 1 ]
then
	VERIFYFPRM=$FILE_IN
else
	VERIFYFPRM=$PARMDIR/PARMFILE-COMPU13.txt
fi
if [ $OUTFILE_FLG = 1 ]
then
	VERIFYFLOG=$FILE_OUT
else
	VERIFYFLOG=$OUTLOGDIR/compu13log_$DATE.txt
fi
export VERIFYFPRM VERIFYFLOG

# Submit program
date
runcobol ${OBJ_DIR}/compu13
RETVAL=$?
date

echo "RETVAL=$RETVAL"

exit $RETVAL
