#!/bin/sh
#
# Program Name	: nsde004.sh
# Description   : Create CSV Report from NSDEOVRMAS file
#		  Command line input:
#		  -o <NSDE004CSV filename>    (Optional)
#			(Default is ${HOME}/NSDEOVR.csv)
# Author	: Janice L. Lanzo
# Date		: 03/02/2015
# Modifications : 03/17/2015 - updates for production version

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

usage: nsde004.sh [-o NSDE004CSV filename]

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


# Submit nsde004 program
submit_nsde004()
{
     runcobol ${OBJ_DIR}/nsde004    
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -o) shift
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

# Assign alternate environment variables
if [ $FILE_FLAG = 1 ]
then
	NSDE004CSV=$FILE
else
	NSDE004CSV=${HOME}/NSDEOVR.csv
fi
export NSDE004CSV    

echo "CSV Report from NSDEOVRMAS"
date
echo "NSDEOVRMAS=${NSDEOVRMAS}"
echo "NSDE004CSV=${NSDE004CSV}"
submit_nsde004 
date

exit 0
