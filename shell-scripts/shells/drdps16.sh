#!/bin/ksh
#
# Program Name	: drdps16.sh
#                 Command line arguments:
#                 -i Input Filename (DPS required tape file)
# Description   : DRUGWRKMAS Type Code 16 Update                    
# Author	: Debbie Wilson          
# Date		: 11/24/98
# Modifications : 12/01/98 - Added check for no input file being sent in  (LSJ)
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

usage: drdps16.sh [-i <filename>]  

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

# Submit drdps16 program
submit_drdps16()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drdps16

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
        INPUT_FILE=$1
        ;;
   esac
   shift
done


# Parse environment variables
parse_env

# Assign other variables
if [ ${INPUT_FILE} = "null" ]
then
  usage
else
  DPSTP00TAP=${INPUT_FILE}
  export DPSTP00TAP
fi
DRUGWRKMAS=/usr/lnk/drug/DRUG00MAS.type16
export DRUGWRKMAS


echo DPS Type Code 16 Update         
date
echo "EXPORT PATHS:"
echo "   DPSTP00TAP=$DPSTP00TAP"

submit_drdps16
date

exit 0
