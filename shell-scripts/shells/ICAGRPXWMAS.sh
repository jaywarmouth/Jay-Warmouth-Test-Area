#!/bin/sh
# Program Name  : ICAGRPXWMAS.jl
# Description   : Initialize CAGRPXWMAS new fields
#
# Modifications : 20250416

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
#OBJ_DIR="/usr/lnk/obj"
OBJ_DIR="/home/jlanzo/cobol/cob"
LINKAGE=""
TEST_MODE="N"
PASS1="Y"
FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: icagrpxw0mas.jl -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
                -f <file>       - assign alternate SPONS00MAS

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


# Submit icagrpxwmas program
submit_icagrpxwmas()
{
     runcobol ${OBJ_DIR}/ICAGRPXWMAS -a ${LINKAGE}
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
        CAGRPXWMASI=$FILE
        CAGRPXWMASR=$FILE
else
        CAGRPXWMASI=${CAGRPXWMAS}
        CAGRPXWMASR=${CAGRPXWMAS}
fi
export CAGRPXWMASI CAGRPXWMASR

CAGRPXWUPDTI=/tmp/CAGRPXWUPDTI;export CAGRPXWUPDTI
CAGRPXWUPDTO=/tmp/CAGRPXWUPDTO;export CAGRPXWUPDTO

echo "Initialize CAGRPXWMAS new fields"
date
echo "CAGRPXWMASI=${CAGRPXWMASI}"
echo "CAGRPXWMASR=${CAGRPXWMASR}"
echo "CAGRPXWUPDTI=${CAGRPXWUPDTI}"
echo "CAGRPXWUPDTO=${CAGRPXWUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_icagrpxwmas
date

exit $RETVAL
