#!/bin/ksh
#
# Program Name	: group17.sh
# Description   : Move GROUP Work File to GROUP00MAS
#                 Command line arguments:
#		  -i <filename> - Input GROUP work file
#		  -o <filename> - Name of GROUP file to update (OPTIONAL)
#			if not used file updated will be normal GROUP00MAS
# Author	: Dave Tucci
# Date		: 10/25/99
# Modifications : 10/28/99 - (LSJ) Added -i and -o command line arguments
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INPUT_FILE="null"
OUTPUT_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group17.sh [-i <filename>] [-o <filename>] 

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

#

# Submit group17 program
submit_group17()
{
    runcobol ${OBJ_DIR}/group17
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
        else
          INPUT_FILE=$1
        fi
        ;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        else
          OUTPUT_FILE=$1
        fi
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${OUTPUT_FILE} != "null" ]
then
   GROUP00MAS=${OUTPUT_FILE}
   export GROUP00MAS
fi
GRPWRK0MAS=${INPUT_FILE}
export GRPWRK0MAS


date

echo "GROUP00MAS=${GROUP00MAS}"
echo "GRPWRK0MAS=${GRPWRK0MAS}"

submit_group17 

date

exit 0
