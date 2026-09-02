#!/bin/ksh
#
# Program Name  : dea001.cbl 
# Description   : UPDATE DEA TAPE FILE TO DEA MASTER FILE
#                 Command Line Arguments:
#                 -i <filename> - input file name
# Author        : Jim Masluk
# Date          : 07/31/2000
# Modifications : 10/25/2001 - Added status check for input file  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
INPUT_FILE="null"
STAT_FILE="/tmp/cpdea_flag"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dea001.sh [-i <filename>]

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


# Submit dea001 program
submit_dea001()
{
#	if test -a ${STAT_FILE}
#	then
           runcobol ${OBJ_DIR}/dea001
#	else
#	   echo ""
#	   echo "-*> Possible problem with rcp of DEA00RB001"
#	   echo "-*> dea001 will not run..."
#	   exit 1
#	fi

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
          INPUT_FILE=$1
          ;;
   esac
   shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INPUT_FILE} = "null" ]
then
   usage
else
   DEA000TAP=${INPUT_FILE}
   export DEA000TAP 
fi

echo "DEA FILE UPDATE"
echo "EXPORT FILES:"
echo "   DEA000TAP=${DEA000TAP}"
echo "   DEA000MAS=${DEA000MAS}"
date
submit_dea001  
date

exit 0
