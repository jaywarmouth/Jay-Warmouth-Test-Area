#!/bin/ksh
#
# Program Name  : phnet16.sh
# Description   : Pharmacy Screen List
#		  Command Line Arguments:
#                 -a Userclass & Username
#		  -z Demo Switch
# Author        : James Masluk
# Date          : 05/22/01
# Modifications : 
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

usage: phnet16.sh -a ["userclass&username"] [-z]

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



# Submit phnet16 program
submit_phnet16()
{
        runcobol ${OBJ_DIR}/phnet16 -a ${USERCLASS}${USER}'             '  
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


echo $USER
echo $USERCLASS

date
submit_phnet16
date

exit 0
