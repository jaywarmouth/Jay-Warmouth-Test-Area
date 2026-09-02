#!/bin/bash
#
#
# Program Name	: clmcyc02.sh 

# Description   : add, update, or delete records in the CLAIM00MAS master file  
# 
# Author	: Lucy A. Caraballo
# Date		: 09/19/2024
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE="0"
DEBUG_MODE="0"
RETVAL=0
INFILE_FLG=0
OUTFILE_FLG=0
RETVAL=0
HOSTSYS=`/usr/bin/hostname -s`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmcyc02.sh -i <input CLWRK file> -o <optional CLAIM00MAS file name>
	Input CLWRK file name is required.             
   
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

	
# Submit clmcyc02 program
submit_clmcyc02()
{

        runcobol ${OBJ_DIR}/clmcyc02 -s ${TEST_MODE}${DEBUG_MODE}  
         RETVAL=$?   
}      

#
# Main routine
#
#Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
	usage
fi
while [ $# -gt 0 ]
do
  case "$1"
  in  
    -s) TEST-MODE=1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	OUTFILE_FLG=1
        OUTFILE=$1
        ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INFILE_FLG=1
        INFILE=$1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $INFILE_FLG = 1 ]
then
	CLWRK00MAS=$INFILE; export CLWRK00MAS
fi
if [ $OUTFILE_FLG = 1 ]
then
        CLAIM00MAS=$OUTFILE; export CLAIM00MAS
fi

#FG4AUD=/usr/lnk/wrk/FG4AUD-LC                              
#  export FG4AUD

date
echo "EXPORT PATHS:"
echo "   SERVER=${HOSTSYS}"
echo "   CLWRK00MAS=$CLWRK00MAS "
echo "   CLAIM00MAS=$CLAIM00MAS "

submit_clmcyc02


echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
