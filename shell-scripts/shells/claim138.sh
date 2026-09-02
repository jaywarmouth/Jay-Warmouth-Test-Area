#!/bin/sh
#
# Program Name	: claim138.sh 
# Description   : Unload indexed file CLAIM00MAS, linked with CLMSS00MAS, 
#                 to a sequential file in csv form
# Author	: William Swidal 
# Date		: 11/04/2016
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim138.sh -p <CLAIM138PRM input file, defaults to /usr/lnk/wt/oper-wt/misc/CLAIM138PRM.txt> 
                   -c <CLAIM00MAS input file, defaults to system value>
                   -s <CLMSS00MAS input file, defaults to system value>
                   -o <CLMSSEXTCAV output file, defaults to /usr/lnk/wt/oper-wt/misc/CLAIMEXTCSV-YYYYMMDD-hhmmss.txt>

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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

	
# Submit stepcpy program
submit_claim138()
{
    runcobol ${OBJ_DIR}/claim138 ${DEBUG} -k
    RETVAL=$?
}

#
# Main routine
#
# Parse environment variables
parse_env

CLAIM138PRM=/usr/lnk/wt/oper-wt/misc/CLAIM138PRM.txt

DATETM=`date +%Y%m%d-%H%M%S`
CLAIMEXTCSV=/usr/lnk/wt/oper-wt/misc/CLAIMEXTCSV-${DATETM}.txt

DEBUG=" "

#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLAIM138PRM=$1
        ;; 
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLAIM00MAS=$1
        export CLAIM00MAS
        ;;
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLMSSMAS=$1
        export CLMSSMAS
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLAIMEXTCSV=$1
        ;;
    -d) DEBUG="D"
        ;;
     *) usage
        ;;
  esac
  shift
done 

# Assign alternate environment variables
export CLAIM138PRM
export CLAIMEXTCSV

echo "GENERATE A CLAIM00MAS|CLMSSMAS CSV FILE"
date
echo "EXPORT PATHS:"
echo "   CLAIM138PRM=$CLAIM138PRM"
echo "   CLMSS00MAS=$CLMSS00MAS"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLAIMEXTCSV=$CLAIMEXTCSV"
#read dummy

submit_claim138
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
