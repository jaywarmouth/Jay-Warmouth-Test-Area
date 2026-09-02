#!/bin/ksh
#
# Program Name  : phnet01.sh
# Description   : Pharmacy Network Load
#                 Command Line Arguments
#                 -a <username>
#		  -f <alt. file path and name>  Optional
#		  -d <mmddyy> - date suffix for NCPDPADDLN input filename
# Author        : David Tucci
# Date          : 11/10/97
# Modifications : 07/06/2001 - Changes for option to send in an input file (LSJ)
#		: 09/12/2001 - Changed FILE_DIR path  (LSJ)
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
FILE_FLAG=0             
INPUT_FILE=0
FILE_DIR="/usr/upd/pharm"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet01.sh -a <username> -f <filename> -d <mmddyy>
        -a <username> - username of person running this procedure (REQUIRED)
        -f <filename> - to input alt. path and name for NCPDPADDLN (OPTIONAL) 
        -d <mmddyy> - date suffix for NCPDPADDLN input filename (OPTIONAL)

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


# Submit phnet01 program
submit_phnet01()
{
     echo ${DATE}
     if [ ${INPUT_FILE} = 1 ]
       then
        runcobol ${OBJ_DIR}/phnet01 -s 1 -a ${USER}'           '
       else
        runcobol ${OBJ_DIR}/phnet01 -s 0 -a ${USER}'           '
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
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USER=$1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
  	FILE_FLAG=1
	INPUT_FILE=1
	FILENAME=$1
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	INPUT_FILE=1
	DATE=$1
	;;
  esac
  shift
done


# Parse environment variables
parse_env


# Assign alternate environment variables
FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD

if [ ${INPUT_FILE} = 1 ]
then
  if [ ${FILE_FLAG} = 1 ]
  then
    NCPDPADDLN=${FILENAME}
  else
    NCPDPADDLN=${FILE_DIR}/NCPDPADDLN${DATE}
  fi
  export NCPDPADDLN
fi

date
submit_phnet01
date

exit 0
