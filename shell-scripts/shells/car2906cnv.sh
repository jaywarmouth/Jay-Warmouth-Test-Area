#!/bin/sh
#
# Program Name  : car2906cnv.sh
#                 Command Line argument:
#                 -i <car29in filename> - e.g zel0309
# Description   : Line by line copy of car29in file.
#
#
# Author        : Lucy Caraballo
# Date          : 03/09/2023
# Modifications :
#               :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE="null"
DIR="/usr/lnk/elig_in"
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: car2906cnv.sh -i <??emmdd>

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


# Submit car2906cnv program
submit_car2906cnv()
{
      runcobol ${OBJ_DIR}/car2906cnv
      RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $FILE = "null" ]
then
        usage
        exit 1
fi

 CAR29IN=$DIR/$FILE
  export CAR29IN
 CAR29OUT=$DIR/$FILE.lin
  export CAR29OUT

echo COPY CAR29IN INPUT FILE
date
echo "EXPORT PATHS:"
echo "   CAR29IN=$CAR29IN"
echo "   CAR29OUT=$CAR29OUT"

submit_car2906cnv
date

exit $RETVAL

