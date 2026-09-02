#!/bin/ksh
#
# Program Name	: drdps16term.sh
#                 Command line arguments:
#                 -d Set chg date of drdps16 update <ccyymmdd>
# Description   : DPS 16 Delete Non-Touched                         
# Author	: Debbie Wilson          
# Date		: 11/08/99
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
INPUT_FILE="null"
DATE=0            
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drdps16term.sh [-d <ccyymmdd>]

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit drdps16term program
submit_drdps16term()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drdps16term -a ${DATE} 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
   case "$1"
   in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
   esac
   shift
done


# Parse environment variables
parse_env

# Assign other variables
DRUGWRKMAS=/usr/lnk/drug/DRUG00MAS.type16
export DRUGWRKMAS 

echo DPS Type Code 16 Delete Non-touched
date
echo "EXPORT PATHS:"

submit_drdps16term
date

exit 0
