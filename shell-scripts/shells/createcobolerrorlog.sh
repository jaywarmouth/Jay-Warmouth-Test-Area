#!/bin/sh
#
# Script Name	: createcobolerrorlog.sh
# Description	: Runs createcobolerrorlog program that creates initial empty COBOLERRORLOG file.
#		  Command Line options:
#		  -f <alternate directory and filename for COBOLERRORLOG>
# Author	: Linda S. Jefferis
# Date		: 10/17/2012
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: createcobolerrorlog.sh -f <file name>
	-f is optional.  If not used will use what is assigned in env_var.

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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

if [ $FILE_FLAG = 1 ]
then
	COBOLERRORLOG=$FILE
	export COBOLERRORLOG
fi

echo "Create blank COBOLERRORLOG file"
echo "   COBOLERRORLOG=$COBOLERRORLOG"
date
runcobol ${OBJ_DIR}/createcobolerrorlog
date

exit 0
