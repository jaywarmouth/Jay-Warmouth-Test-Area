#!/bin/ksh
#
# Program Name  : drugcms01.sh  
# Description   : CMS Medicare Pricing File Creation                       
#                 Command line arguments:
#                 -h History run w/alternate date <ccyymmdd>
# Author        : Debbie Wilson    
# Date          : 02/09/04
# Modifications : 04/25/05 - Added history switch and alternate date.
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HISTORY_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drugcms01.sh [-h <ccyymmdd>]  

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


# Submit drugcms01 program   
submit_drugcms01()
{
   if [ ${HISTORY_RUN} = 1 ]
   then
      runcobol ${OBJ_DIR}/drugcms01 -s 1 -a ${DATE} 
   else
      runcobol ${OBJ_DIR}/drugcms01 
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
    -h) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        HISTORY_RUN=1
        DATE=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

umask 000

# Assign alternate environment variables

date
submit_drugcms01          
date

exit 0
