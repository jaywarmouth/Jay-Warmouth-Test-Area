#!/bin/sh
# Program Name  : ICABIN00MAS.fl
# Description   : Initialize CABIN00MAS new fields
#   
# Modifications : 20250923

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

usage: icabin00mas.fl -t -m -f <file>
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


# Submit iCABIN00MAS program
submit_iCABIN00MAS()
{
#     runcobol ${OBJ_DIR}/ICABIN00MAS -a ${LINKAGE}
    runcobol ${OBJ_DIR}/ICABIN00MAS -a NY D
#    runcobol ${OBJ_DIR}/ICABIN00MAS -a NN D
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

CABIN00MASO=/usr/lnk/rmfiles/CABIN00MASO
#CABIN00MASO=/home/flim/test/CABIN00MASO
export CABIN00MAS

if [ ${FILE_FLAG} = 1 ]
then
        CABIN00MASI=$FILE
        CABIN00MASR=$FILE
else
        CABIN00MASI=/usr/lnk/rmfiles/CABIN00MASI
        CABIN00MASR=/usr/lnk/rmfiles/CABIN00MASR
        #CABIN00MASI=/home/flim/test/CABIN00MASI
        #CABIN00MASR=/home/flim/test/CABIN00MASR
fi
export CABIN00MASI CABIN00MASR
CABIN00UPDTI=/usr/lnk/rmfiles/CABIN00UPDTI; export CABIN00UPDTI
CABIN00WUPDTO=/usr/lnk/rmfiles/CABIN00UPDTO; export CABIN00UPDTO
#CABIN00UPDTI=/home/flim/test/CABIN00UPDTI; export CABIN00UPDTI
#CABIN00WUPDTO=/home/flim/test/CABIN00UPDTO; export CABIN00UPDTO

echo "Initialize CABIN00MAS new fields"
date
echo "CABIN00MASI=${CABIN00MASI}"
echo "CABIN00MASR=${CABIN00MASR}"
echo "CAGRPXWUPDTI=${CAGRPXWUPDTI}"
echo "CAGRPXWUPDTO=${CAGRPXWUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_iCABIN00MAS
date

exit $RETVAL
