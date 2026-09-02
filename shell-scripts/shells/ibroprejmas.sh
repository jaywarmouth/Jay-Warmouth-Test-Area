#!/bin/sh
# Program Name	: ibroprejmas.sh
# Description   : Initialize BROPREJMAS new fields
#                                 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
LINKAGE=""
TEST_MODE="N"
PASS1="Y"
FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ibroprejmas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate BROPREJMAS

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


# Submit ibroprejmas program
submit_ibroprejmas()
{
     runcobol ${OBJ_DIR}/IBROPREJMAS -a ${LINKAGE}
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
        BROPREJMASI=$FILE
	BROPREJMASR=$FILE
else
        BROPREJMASI=${BROPREJMAS}
        BROPREJMASR=${BROPREJMAS}
fi

BROPREJMASI=${BROPREJMASI}
export BROPREJMASI

BROPREJMASR=${BROPREJMASR}
export BROPREJMASR

BROPREJUPDI=${BROPREJUPDI}
BROPREJUPDO=${BROPREJUPDO}
export BROPREJMASI BROPREJMASR  

echo "Initialize BROPREJMAS new fields"
date
echo "BROPREJMASI=${BROPREJMASI}"
echo "BROPREJMASR=${BROPREJMASR}"
echo "BROPREJUPDI=${BROPREJUPDI}"
echo "BROPREJUPDO=${BROPREJUPDO}"
echo "LINKAGE=${LINKAGE}"
submit_ibroprejmas 
date

exit $RETVAL
