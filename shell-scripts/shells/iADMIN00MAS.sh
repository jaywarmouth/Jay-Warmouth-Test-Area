#!/bin/ksh
# to run: iconfig0mas.sh
#     I ran script without parameters as these are in RUNCOBOL statement
# modify rmcobol command with -a TEST-MODE(Y OR N) FIRST-PASS (Y OR NO) BEGBATCH & ENDBATCH to execute at runtime
#  will take length of linkage of:
#    2 - test-mode, first-pass
#    10 - test-mode, first-pass, begbatch
#    16 - test-mode, first-pass, begbatch
#    any other length will cause an error and stop program.
#    if no begbatch or end batch or the value is spaces - it will process the full file.
#
# Program Name  : iADMIN00MAS.sh
# Description   : Initializes new fields in iADMIN00MAS Configuration Master file
#                 Command Line Arguments:
#                  -a
#
# Author        : Ferdinand Lim
# Date          : 10/27/2025
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
FIRST_PASS=1
DEBUG=" "
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage iADMIN00MAS.sh [-t]

ENDOFUSAGE
  exit 1
}

#

#rse environment variables file
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


# Submit iADMIN00MASprogram
submit_iADMIN00MAS()
{
    runcobol ${OBJ_DIR}/IADMIN00MAS -a NY

}
# Main routine#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
    -r) FIRST_PASS=1
        ;;
    -D) DEBUG="D"
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
  
ADMIN00MASR=/usr/lnk/grp/ADMIN00MAS 
 export ADMIN00MASR

ADMIN00MASI=/usr/lnk/grp/ADMIN00MAS
  export ADMIN00MASI

ADMINUPDTI=/usr/lnk/tst/ADMIN00UPDTI
  export ADMINUPDTI

ADMINUPDTO=/usr/lnk/tst/ADMIN00UPDTO
  export ADMINUPDTO


echo "Initialize ADMIN00MAS new fields"
date
echo "ADMIN00MASR=${ADMIN00MASR}"
echo "ADMIN00MASI=${ADMIN00MASI}"
echo "ADMINUPDTI=${ADMINUPDTI}"
echo "ADMINUPDTO=${ADMINUPDTO}"
submit_iADMIN00MAS
echo  "   RET_CODE=$? "
date

exit 0
