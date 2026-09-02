#!/bin/sh
# Program Name	: igroup00mas.sh
# Description   : Initialize GROUP00MAS new fields
#                
#          Command Line Arguments: 
#          -t Test Mode  
#                 
# Author	: Janice L. Lanzo
# Date		: 12/02/2014
# Modifications : 12/10/2014
#		: 07/27/2017 - TT17462-1
#		: 1/4/2018 - TT17884-1; program logic reworked.

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

usage: igroup00mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate GROUP00MAS

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


# Submit igroup00mas program
submit_igroup00mas()
{
     runcobol ${OBJ_DIR}/IGROUP00MAS -a ${LINKAGE}
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
        GROUP00MASI=$FILE
	GROUP00MASR=$FILE
else
        GROUP00MASI=${GROUP00MAS}
        GROUP00MASR=${GROUP00MAS}
fi
export GROUP00MASI GROUP00MASR  
GROUPUPDTI=/tmp/GROUPUPDTI; export GROUPUPDTI
GROUPUPDTO=/tmp/GROUPUPDTO; export GROUPUPDTO

echo "Initialize GROUP00MAS new fields"
date
echo "GROUP00MASI=${GROUP00MASI}"
echo "GROUP00MASR=${GROUP00MASR}"
echo "GROUPUPDTI=${GROUPUPDTI}"
echo "GROUPUPDTO=${GROUPUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_igroup00mas 
date

exit $RETVAL
