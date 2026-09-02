#!/bin/sh
# Program Name	: istcomp0mas.sh
# Description   : Initialize STCOMP0MAS new fields
#                                 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/tst/amurugan"
LINKAGE=""
TEST_MODE="N"
PASS1="Y"
FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: istcomp0mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate STCOMP0MAS

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


# Submit istcomp0mas program
submit_istcomp0mas()
{
     runcobol ${OBJ_DIR}/ISTCOMP0MAS -a ${LINKAGE}
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
        STCOMP0MASI=$FILE
	STCOMP0MASR=$FILE
else
        STCOMP0MASI=${STCOMP0MAS}
        STCOMP0MASR=${STCOMP0MAS}
fi

STCOMP0MASI=/usr/devl/users/amurugan/STCOMP/STCOMP0MAS
export STCOMP0MASI

STCOMP0MASR=/usr/devl/users/amurugan/STCOMP/STCOMP0MAS
export STCOMP0MASR

export STCOMP0MASI STCOMP0MASR  
STCOMPUPDTI=/usr/devl/users/amurugan/STCOMP/STCOMPUPDTI; export STCOMPUPDTI
STCOMPUPDTO=/usr/devl/users/amurugan/STCOMP/STCOMPUPDTO; export STCOMPUPDTO

echo "Initialize STCOMP0MAS new fields"
date
echo "STCOMP0MASI=${STCOMP0MASI}"
echo "STCOMP0MASR=${STCOMP0MASR}"
echo "STCOMPUPDTI=${STCOMPUPDTI}"
echo "STCOMPUPDTO=${STCOMPUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_istcomp0mas 
date

exit $RETVAL
