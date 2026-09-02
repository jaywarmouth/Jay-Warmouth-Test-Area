#!/bin/ksh
#
# Program Name	: cleanup.sh
# Description	: Removes specified files in arguments
#		  Command Line Arguments:
#		  -f <file path and name>
# Author	: Linda S. Jefferis
# Date		: 02/04/2002
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cleanup.sh -f <file path and name>

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
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

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
  esac
  shift
done

# Parse environment variables
#parse_env

rm -f ${FILE}

exit 0
