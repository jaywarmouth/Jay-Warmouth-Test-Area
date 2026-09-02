#!/bin/bash
#
# Program Name	: clmcyc01.sh    
# Description   : PULL CLAIMS TO WORK FILE BY T-OFF-CYCLE
#                 Command line arguments:
#                 -b <batch range>  
#		  -c <W|X|P|T>
#		  -o <output file>
#		  -i <alt. inout file>
#
# Author	: Lucy A. Caraballo
# Date		: 08/29/2024
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
BATCH_RANGE="NULL"
CYCLE="NULL"
FILE_FLAG=0
OUTPUT_FILE="null"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmcyc01.sh [-b <batchrange> -c <W|X|P|T> -i <input file> -o <output file>]
where
	batchrange - required; 16-character batch range
	-c <cycle type> - required; one of designated cycle type characters
	input file - optional; alternate input CLAIM00MAS file
	output file - required; output clwrk file
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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Validate -c options
validate_cycle()
{  case ${CYCLE} in
     "W" | "P" | "X" | "T")
        ;;
     *)
        echo "-*> Invalid cycle entered"
	usage 
        ;;
    esac
}  


# Submit clmcyc01 program
submit_clmcyc01()
{
   runcobol ${OBJ_DIR}/clmcyc01 -a ${BATCH_RANGE}${CYCLE}                        
   RETVAL=$?
}

#
# Main routine
# Check command line validity, call usage if incorrect
if [ $# -lt 6 ]
then
	usage
fi
while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCH_RANGE=$1
        ;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	CYCLE=$1
	validate_cycle
	;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTPUT_FILE=$1
        ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done

#
# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $BATCH_RANGE = "NULL" ]
then
	usage
fi
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi
CLWRK00MAS=${OUTPUT_FILE}
export CLWRK00MAS


echo "Claims to work - clmcyc01"
date
echo
echo "CLAIM00MAS=$CLAIM00MAS"
echo "CLWRK00MAS=$CLWRK00MAS"

date

# Submit the program
if [ ${OUTPUT_FILE} = "null" ]
then
  usage
else
  submit_clmcyc01 
fi

echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
