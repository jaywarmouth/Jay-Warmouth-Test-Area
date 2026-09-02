#!/bin/sh
#
# Program Name  : drug016.sh
# Description   : Drug Inquiry by Cardholder or Group
#                 Command Line Arguments
#                 -s Group Inquiry (no -s means Cardholder Inquiry)
#		  -a <userclass> <username>
#		  -z Demo switch
# Author        : Christina Harris
# Date          : 08/29/97
# Modifications : 11/10/99 - Added Demo switch  (LSJ)
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
GROUP_CARD_FLAG=0
DEMO=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug016.sh [-s] -a ["userclass&username"]

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


# Submit drug016 program
submit_drug016()
{
   if [ ${GROUP_CARD_FLAG} = 1 ]
   then
        runcobol ${OBJ_DIR}/drug016 -s 1 -a ${USERCLASS}${USER}'           '
   else
        runcobol ${OBJ_DIR}/drug016 -s 0 -a ${USERCLASS}${USER}'           '
   fi

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) GROUP_CARD_FLAG=1
        echo ${GROUP_CARD_FLAG}
        ;;
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

echo Drug Inquiry by Cardholder or Group
date
submit_drug016
date

exit 0
