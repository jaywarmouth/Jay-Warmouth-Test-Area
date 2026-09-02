#!/bin/ksh
#
# Program Name  : aretraf.sh
# Description   : ETRAF00MAS Archive/Extract    
# Author        : Bill Swidal 
# Date          : 10/10/2016
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj

FILE_DIR=/usr/lnk/claims
ARCH_DIR=/usr/lnk/claims
PARM_DIR=/usr/lnk/log

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: aretraf.sh [-a] [-i filename] [-o filename] [-p filename] [-t]
           [-a <change output mode from EXTRACT (default) to ARCHIVE>] 
           [-i filename <overrides ETRAF00MAS with filename>] 
           [-o filename <overrides ETRAFARMAS with filename>] 
           [-p filename <ETRARCHP filename> (defaults to /usr/lnk/log/ETRARCHP.txt)]
           [-t <run in testmode, where no real file updates occur>]
       All switches are optional

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


# Submit arlimit program
submit_aretraf()
{
    runcobol ${OBJ_DIR}/aretraf ${DEBUG} -a ${OUTPUT_MODE}${TEST_MODE}
    RETVAL=$?
}


#
# Main routine
#

ETRAFARMAS=${ARCH_DIR}/ETRAFARMAS
ETRARCHP=${PARM_DIR}/ETRARCHP.txt

# Parse environment variables
parse_env
# Check command line validity, call usage if incorrect

TEST_MODE=0
#  (defaulting to the non-destructive mode)
OUTPUT_MODE="E"
DEBUG=" "

while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) OUTPUT_MODE="A"
        ;;

    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ETRAF00MAS=$1
	export ETRAF00MAS
        ;;

    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ETRAFARMAS=$1
        ;;

    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	ETRARCHP=$1
        ;;

    -t) TEST_MODE=1
        ;;

    -d) DEBUG="D"
        ;;

     *) usage
  esac
  shift
done

# for testing:
#cp ${FILE_DIR}/ETRAF00MAS_HOLD ${FILE_DIR}/ETRAF00MAS
#ETRAF00MAS=${FILE_DIR}/ETRAF00MAS
#export ETRAF00MAS

if [ ${OUTPUT_MODE} = "E" ]
then
  DATE=`date +%Y%m%d`
  ETRAFARMAS=${ETRAFARMAS}-${OUTPUT_MODE}-${DATE}
else
  ETRAFARMAS=${ETRAFARMAS}-${OUTPUT_MODE}
fi
export ETRAFARMAS

export ETRARCHP


date
echo "EXTRACT / ARCHIVE ETRAF00MAS RECORDS"
echo ""
echo "EXPORTED FILES:"
echo "     ETRAF00MAS=$ETRAF00MAS"
echo "     ETRAFARMAS=$ETRAFARMAS"
echo "     ETRARCHP=$ETRARCHP"
echo "OUTPUT_MODE=$OUTPUT_MODE"
echo "TEST_MODE=$TEST_MODE"
#read dummy

submit_aretraf
date

exit ${RETVAL}
