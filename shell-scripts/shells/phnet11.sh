#!/bin/ksh
#
# Program Name  : phnet11.sh
# Description   : Pharmacy Screen List
#		  Command Line Arguments:
#		  -z Demo Switch
# Author        : David Tucci
# Date          : 10/30/98
# Modifications : 03/04/99 - DAT - Added Userclass & Username
#		  11/10/99 - (LSJ) Added demo switch logic
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

usage: phnet11.sh -a ["userclass&username"] [-z]

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



# Submit phnet11 program
submit_phnet11()
{
        runcobol ${OBJ_DIR}/phnet11 -a ${USERCLASS}${USER}'             '
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
submit_phnet11
date

exit 0
