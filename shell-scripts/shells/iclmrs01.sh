#!/bin/sh
# Program Name	: iclmrs01.sh
# Description   : Initialize CLMRS00MAS new fields
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Janice L. Lanzo
# Date		: 12/08/2014
# Modifications : 12/10/2014 - Changes for production

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: iclmrs01.sh -t -f <iclaimparm filename>
	both are optional

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


# Submit iclaim01 program
submit_iclmrs01()
{
     runcobol ${OBJ_DIR}/iclmrs01 -s ${TEST_MODE}      
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

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
        ICLAIMPARM=$FILE
else
        ICLAIMPARM=/usr/lnk/misc/ICLAIMPARM.txt
fi
export ICLAIMPARM

echo "Initialize CLMRS00MAS new fields"
date
echo "CLMRS00MAS=${CLMRS00MAS}"
echo "ICLAIMPARM=${ICLAIMPARM}"
submit_iclmrs01 
date

exit 0
