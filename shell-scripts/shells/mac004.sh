#!/bin/ksh
#
# Program Name  : mac004.sh
# Description   : Update mac table 14 from mac table 20
#		  Command Line Arguments:
#		: -z sample/demo flag 
# Author        : Mike Paulus 
# Date          : 06/30/2009
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

usage: mac004.sh 

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


# Submit mac004 program
submit_mac004()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/mac004  

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

echo "Update mac table 14 from mac table 20"
date
submit_mac004
date

exit 0
