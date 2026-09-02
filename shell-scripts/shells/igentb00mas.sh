#!/bin/sh
# Program Name	: igentb00mas.sh
# Description   : Initialize GENTB00MAS new fields
#                
#          Command Line Arguments: 
#          -t Test Mode  
#                 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
LINKAGE=""
TEST_MODE="N"
PASS1="Y"
FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: igentb00mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate GENTB00MAS

ENDOFUSAGE
  exit 99
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


# Submit igentb00mas program
submit_igentb00mas()
{
     runcobol ${OBJ_DIR}/IGENTB00MAS -a ${LINKAGE}
	RETVAL=$?
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

# Assign alternate environment variables
LINKAGE=${TEST_MODE}${PASS1}

if [ ${FILE_FLAG} = 1 ]
then
        GENTB00MASI=$FILE
	GENTB00MASR=$FILE
else
        GENTB00MASI=${GENTB00MAS}
        GENTB00MASR=${GENTB00MAS}
fi
export GENTB00MASI GENTB00MASR  
GENTBUPDTI=/tmp/GENTBUPDTI; export GENTBUPDTI
GENTBUPDTO=/tmp/GENTBUPDTO; export GENTBUPDTO

echo "Initialize GENTB00MAS new fields"
date
echo "GENTB00MASI=${GENTB00MASI}"
echo "GENTB00MASR=${GENTB00MASR}"
echo "GENTBUPDTI=${GENTBUPDTI}"
echo "GENTBUPDTO=${GENTBUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_igentb00mas 
date

exit $RETVAL
