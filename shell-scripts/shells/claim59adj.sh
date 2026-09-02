#!/bin/ksh
#
# Program Name  : claim59adj.sh
# Description   : Pharmacy Demographic Term 
#                 Command line arguments:
#                 -b Start and Stop Batch Range
# Author        : Deborah Wilson  
# Date          : 07/22/98
# Modifications : 02/24/2006 - Added umask command temporarily  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/misc
USER=""
BATCH=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim59adj.sh [ -b "start&stopbatchrange" ]

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


# Submit claim59adj program
submit_claim59adj()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/claim59adj  -a ${BATCH} 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
     -b) shift   
         if [ $# -le 0 ]
         then
           usage
         fi
         BATCH=$1
         ;;
  esac
  shift
done

# Parse environment variables
parse_env

umask 000

# Assign alternate environment variables

date
submit_claim59adj
date

exit 0
