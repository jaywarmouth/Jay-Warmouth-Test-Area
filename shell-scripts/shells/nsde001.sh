#!/bin/sh
#
# Program Name	: nsde001.sh
# Description   : Compare Comprehensive Formulary file and NSDE file
#                 Update NDCLOCK file
#                 Command line arguments:
#                 -t Test Mode
# Author	: Janice L. Lanzo
# Date		: 10/09/2014
# Modifications : 10/31/2014 - Changes for production version  (LSJ)

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nsde001.sh [-t]

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


# Submit nsde001 program
submit_nsde001()
{
     runcobol ${OBJ_DIR}/nsde001 -s ${TEST_MODE}  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
  
FORM000MAS=/usr/upd/drug/FORM000MAS
  export FORM000MAS

NSDE001CSV=/usr/lnk/misc/NSDE001RPT-${DATE}.csv
  export NSDE001CSV 
   

echo "NSDE001 Process"
date
echo "FILE ASSIGNMENTS:"
echo "	FORM000MAS=${FORM000MAS}"
echo "	NSDE000MAS=${NSDE000MAS}"
echo "	NDCLOCKMAS=${NDCLOCKMAS}"
echo "	FG4AUD=${FG4AUD}"
echo "	NSDE001CSV=${NSDE001CSV}"
submit_nsde001 
date

exit 0
