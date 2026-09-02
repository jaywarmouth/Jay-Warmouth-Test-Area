#!/bin/ksh
#
# Program Name  : ncpdp04.sh
# Description   : NCPDP File Intermidiate "M" Update
# Author        : Mike Paulus
# Date          : 06/11/2008
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%y`
OBJ_DIR=/usr/lnk/obj
USER=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ncpdp04.sh 

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


# Submit ncpdp04 program
submit_ncpdp04()
{
     runcobol ${OBJ_DIR}/ncpdp04 -a ${USER}'           '  
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD

umask 000

echo Alternate and PDM group listing
date
submit_ncpdp04
date

exit 0
