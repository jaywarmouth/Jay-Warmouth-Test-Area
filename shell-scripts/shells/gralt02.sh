#!/bin/ksh
#
# Program Name  : gralt02.sh
# Description   : List Alternate groups for a system
#		  Command Line Arguments:
#                 -i Type of run(sys,spo)                       
#                 -a User & User class
# Author        : Deborah Wilson   
# Date          : 08/10/00
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FORMAT="null"
USER=""
USERCLASS=""

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gralt02.sh [-i sys|spo] -a ["userclass&username"] 

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

#
# Validate -i options
validate_format()
{  case ${FORMAT} in
     "sys" | "spo")
                          ;;
     *)  usage
         ;;
   esac
}

# Submit gralt02 program
submit_gralt02()
{
   if [ ${FORMAT} = "null" ]
   then
     usage
   else
     case ${FORMAT} in
       "sys")
            runcobol ${OBJ_DIR}/gralt02 -s 10 -a ${USERCLASS}${USER}'           '
          ;;
       "spo")
            runcobol ${OBJ_DIR}/gralt02 -s 01 -a ${USERCLASS}${USER}'           '                                             
     esac
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
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FORMAT=$1
        validate_format
        ;;
    -a) shift
        if [ $# -le 0 ]
        then
           usage
        fi
        USERCLASS=$1
        USER=$2
        ;;
   esac
   shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

echo $USER
echo $USERCLASS

echo "Alternate group Listing by System "

date
submit_gralt02
date

exit 0
