#!/bin/ksh
#
# Program Name	: mv-tapes.sh
# Description	: makes copy of Payment Tape TEXT files in rptarch
#		  Command Line Arguments:
#		  -c <pay|off>  Type of cycle
#		  -p <p/e prefix>  e.g. J18
# Author	: Linda S. Jefferis
# Date		: 10/21/1998
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
TAPE_DIR="/usr/lnk/tapes"
RPTARCH="/usr/lnk/rptarch"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv-tapes.sh 

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
# Validate -c options
validate_cycle()
{  case ${CYCLE} in
     "pay" | "off")
                          ;;
     *)  usage
         ;;
   esac
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        validate_cycle
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PREFIX=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

cd ${TAPE_DIR}
find . -name "${PREFIX}*TEXT" -print | cpio -pm ${RPTARCH}/${CYCLE}
find . -name "${PREFIX}*ADJ" -print | cpio -pm ${RPTARCH}/${CYCLE}
find . -name "${PREFIX}????" -exec compress {} \;
find . -name "${PREFIX}????.Z" -print | cpio -pm ${RPTARCH}/${CYCLE}
#cp ${PREFIX}2062 ${RPTARCH}/${CYCLE}

exit 0
