#!/bin/sh
#
# Program Name  : gentb06.sh
# Description   : Create Generic Table File For RXEOB
#                 Command line arguments:
#                   -l System Link (ex.- MEDB, TSC)
#		    -f <filename> - GENTB0FILE filename
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SYSLINK=" "

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gentb06.sh -l ["system link"] -f <GENTB0FILE filename>

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


# Submit gentb06 program
submit_gentb06()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/gentb06 -a ${SYSLINK}'     ' 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -l) shift
        if [ $# -le 0 ]
        then
           usage
        fi
        SYSLINK=$1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
           usage
        fi
        OUTFILE=$1
        ;;
   esac
   shift
done

# Parse environment variables
parse_env

umask 002

# Assign alternate environment variables
GENTB0FILE=${OUTFILE}
export GENTB0FILE

date

echo ""
echo "SYSLINK=$SYSLINK"
echo "GENTB0FILE=$GENTB0FILE"

submit_gentb06
date

exit 0
