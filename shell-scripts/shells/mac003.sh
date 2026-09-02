#!/bin/ksh
#
# Program Name  : mac003.sh
# Description   : MAC File Extract for RXEOB
#		  Command Line Arguments:
#		: -z sample/demo flag 
# Author        : James Masluk
# Date          : 03/22/2004
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SAMP_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mac003.sh 

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


# Submit mac003 program
submit_mac003()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/mac003 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -z) SAMP_FLAG=1
	;;
     *) usage
	;;
  esac
  shift
done


# Parse environment variables
parse_env

umask 000

# Assign alternate environment variables
if [ ${SAMP_FLAG} = 1 ]
then
        ENV_FILE="/usr/lnk/demo/env_var.demo"
        parse_env
fi
MAC00RB001=/usr/lnk/rxeob/MAC
export MAC00RB001

echo "MAC Extract for RXEOB"
date
submit_mac003
date

exit 0
