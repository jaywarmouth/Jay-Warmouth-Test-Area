#!/bin/ksh
#
# Program Name  : phnet07.sh
# Description   : List Pharmacies by Network
#		  Command Line Arguments:
#		  -z Demo switch
# Author        : Linda Jefferis  
# Date          : 10/05/2007
# Modifications : Created to handle test env for PMSI
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
USERCLASS=""
DEMO=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet07.sh -a ["userclass&username"] [-z]

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


# Submit phnet07 program
submit_phnet07()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet07 -a ${USERCLASS}${USER}'             '

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) shift
        if [ $# -le 0 ]
        then
           usage
        fi
        USERCLASS=$1
        USER=$2
        ;;
    -z) DEMO=1
	;;
   esac
   shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${DEMO} = 1 ]
then
   ENV_FILE=/usr/lnk/demo/env_var.demo
   parse_env
fi
PHNET00MAS=/usr/tst/pharm/PHNET00MAS; echo PHNET00MAS
PHDEM00MAS=/usr/tst/pharm/PHDEM00MAS; echo PHDEM00MAS

echo $USER
echo $USERCLASS

date
submit_phnet07
date

exit 0
