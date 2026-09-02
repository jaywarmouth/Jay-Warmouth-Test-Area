#!/bin/ksh
#
# Program Name  : formulary01.sh
# Description   : Formulary Drug Search by Name
#                 Command line arguments:
#                 -s Sponsor Level flag
# Author        : Debbie Wilson    
# Date          : 09/18/01
# Modifications : 02/01/05 - Added logic for Sponsor level switch  
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
SPONSOR_LEVEL=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: formulary01.sh -s -a ["userclass&username"]

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


# Submit formulary01 program
submit_formulary01()
{
        runcobol ${OBJ_DIR}/formulary01 -s ${SPONSOR_LEVEL} -a ${USERCLASS}${USER}'           ' 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SPONSOR_LEVEL=1
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

date
submit_formulary01
date

exit 0
