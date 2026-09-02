#!/bin/ksh
#
# Program Name	: initcldem.sh
# Description   : Initialize CLDEM00MAS new fields
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Patrick Murphy
# Date		: 06/26/2026
# Modifications : Production version updates (LSJ-TT:13654-7)


# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: initcldem.sh [-t]

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



#
# Main routine
#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE="Y"
        ;;
    -m) PASS1="N"
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

echo "Initialize CLDEM00MAS new fields"
date
if [ ${FILE_FLAG} = 1 ]
then
        CLDEM00MASI=$FILE
        CLDEM00MASR=$FILE
else
        CLDEM00MASI=${CLDEM00MAS}
        CLDEM00MASR=${CLDEM00MAS}
fi
export CLDEM00MASI CLDEM00MASR

CLDEM00UPDTI=/tmp/CLDEM00UPDTI;export CLDEM00UPDTI
CLDEM00UPDTO=/tmp/CLDEM00UPDTO;export CLDEM00UPDTO

echo "CLDEM00MASI=${CLDEM00MASI}"
echo "CLDEM00MASR=${CLDEM00MASR}"
echo "CLDEM00UPDTI=${CLDEM00UPDTI}"
echo "CLDEM00UPDTO=${CLDEM00UPDTO}"

runcobol ${OBJ_DIR}/ICLDEM00MAS -a NY 
date

exit 0
