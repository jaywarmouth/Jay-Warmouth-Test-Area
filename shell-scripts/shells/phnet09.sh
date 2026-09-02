#!/bin/ksh
#
# Program Name  : phnet09.sh
# Description   : Pharmacy Network Load
#                 Command line arguments:
#                 -f file flag (filename(30-char.) as argument)
#                 -n NCPDP file
# Author        : David Tucci
# Date          : 11/10/97
# Modifications : 10/08/04 NCPDP File (JM)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/wrk/misc
USER=""
ARGUMENT=""
FILE_FLAG=0
NCPDP_FILE=0
#
#Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet09.sh -a ["username"] -f ["path&filename"] -n [ NCPDP file]

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


# Submit phnet09 program
submit_phnet09()
{
     echo ${DATE}
     runcobol ${OBJ_DIR}/phnet09 -s ${FILE_FLAG}${NCPDP_FILE} -a ${USER}'           '   
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
        ARGUMENT=$1
        ;;
    -n) NCPDP_FILE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env


# Assign alternate environment variables
FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD

 if [ ${FILE_FLAG} = 1 ]
    then
      NABPINPUT=${ARGUMENT}
      export NABPINPUT 
 fi

 if [ ${NCPDP_FILE} = 1 ]
    then
      NABPINPUT=/usr/upd/pharm/NABPNCPDP
      export NABPINPUT
 fi


date
submit_phnet09
date

exit 0
