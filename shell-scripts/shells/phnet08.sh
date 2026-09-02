#!/bin/ksh
#
# Program Name  : phnet08.sh
# Description	: Pharmacy Network Listing
#		  Command line arguments:
#		   -a Username
# Author        : David Tucci
# Date          : 02/26/98
# Modifications : 03/11/98 - Added logic for username argument  (LSJ)
#                 05/04/98 - Added display or print logic (DAT)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/po/misc
USER=""
REPLY="0"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet08.sh -a [ "username" ]

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


# Submit phnet08 program
submit_phnet08()
{
clear
echo "\nEnter selection : 1. Run & Print" 
echo "                  2. Run & Display"
echo "                  3. Exit"
while test $REPLY -ne 3
do
  read REPLY
  case $REPLY in
    "1")  runcobol ${OBJ_DIR}/phnet08 -s 0 -a ${USER}'           '
          exit 0;
          ;;
    "2")  runcobol ${OBJ_DIR}/phnet08 -s 1 -a ${USER}'           '
          exit 0;
          ;;
    "3")  exit 0
          ;;
    "*")  echo "Invalid choice\n"
          ;;
  esac
done
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
        USER=$1
echo ${USER}
        ;;
  esac
  shift
done


# Parse environment variables
parse_env


# Assign alternate environment variables

date
submit_phnet08
date

exit 0
