#!/bin/sh
#
# Program Name  : chksumclaim01
# Description   : checksum for CLAIM00MAS.                  
#                 -r is used to pass batch ranges.
#				  this program can be run in the following modes.
#						1) with no parameters				: eg. sh chksumclaim01.sh
#						2) with -r <startbatch> 			: eg. sh chksumclaim01.sh -r UH21W001
#						3) with -r <startbatch><endbatch>	: eg. sh chksumclaim01.sh -r UH21W001UH21W007
# Author        : VIJAY CHANDRAN           
# Date          : 08/20/2020
# Modifications	: T00826 - 08/20/2020 - VP - chksumclaim01 and chksumclaim02 - CEXP - CLAIM00MAS - Checksum Program - (20656-58) 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
CHECKSUM_PATH=/usr/lnk/wt/business_quality
FILE_FLAG=0
DATETM=`date +%Y%m%d-%H%M%S`
LINKAGE=""
BATCH_RANGE=""
NORANGE="NOARGS"
BATCH_FLAG=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: checksum.sh [-r <Batch range>] 

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


# Submit checksum program
submit_checksum()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/chksumclaim01 -a ${LINKAGE} 

}

echo "arguments: $# $* "
#
# Main routine
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCH_RANGE=$1
	BATCH_FLAG=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${BATCH_FLAG} = 1 ]
then
   LINKAGE=${BATCH_RANGE}
else
 LINKAGE=$NORANGE
fi

#INPUT FILES 

CLAIM00MAS=/usr/lnk/clm_01/CLAIM00MAS
export CLAIM00MAS

#OUTPUT FILES:

CHECKSUM=$CHECKSUM_PATH/CHECKSUM_CLAIM00MASO_$DATETM.txt 
  export CHECKSUM

echo "Check sum process for claim00mas - Old file"  
date
echo ""
echo "CLAIM00MAS=$CLAIM00MAS"
echo "CHECKSUM=$CHECKSUM"
echo "LINKAGE:$LINKAGE"
echo ""

submit_checksum

exit 0
