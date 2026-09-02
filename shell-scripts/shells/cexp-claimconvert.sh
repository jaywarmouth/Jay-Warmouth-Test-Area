#!/bin/sh
#
# Program Name  : CLAIMCONVERT.sh
# Author        : wswidal
# Date          : 06/08/2020
#

ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
OUT_DIR=/usr/lnk/conversions
RMCONFIG=/usr/rmcobol/terminfo-d0.cfg
RETVAL=0

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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claimconvert.sh -t <run-type> -p <parmfile> -s <source-file> -b <batchrange> -i <input filename> -o <new output file> -m <msgfile>
    run-type: P (parameter file, listing of 14 character batch/claims; <parmfile> is neccessary)
                R (range; <batchrange> is neccessary, 16 characters)
                F (full, like range but from beginning of file to end of file)
    source-file: C (CLAIM00MAS)
                 R (CLMRS00MAS)
                 V (REVER00MAS; this uses a separate variation of the program due to some differences)
    input filename: overrides the source filename for any input, required for CLWRK00MAS (directory/filename)
    output filename: converted output filename (just filename, not directory)
    msgfile:  msg/error filename (just filename, not directory)
  

ENDOFUSAGE
exit 99
}

#
# Main routine
#

# Parse environment variables
parse_env

# defaults:
BATCHBEG="00000000"
BATCHEND="ZZ99Z999"
INTYPE="R"
SOURCEFILE="C"
INFILE_FLG=0
CREATEORIG="N"

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
	BATCHRANGE=$1
	BATCHBEG=`echo $BATCHRANGE | cut -c1-8`
	BATCHEND=`echo $BATCHRANGE | cut -c9-16`
	;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	PARMFILE=$1
	;;
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INTYPE=$1
        ;;
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SOURCEFILE=$1
        ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INFILE=$1
	INFILE_FLG=1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	OUTFILE=$1
	;;
    -m) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	INFOFILE=$1
	;;
    *)  usage
        ;;
  esac
  shift
done

if [ ${INFILE_FLG} = 1 ]
then
  CLAIM00MASO=${INFILE}
else
  case ${SOURCEFILE} in
    "C") CLAIM00MAS0=${CLAIM00MAS}
	;;
    "R") CLAIM00MASO=${CLMRS00MAS}
	;;
    "V") CLAIM00MASO=${REVER00MAS}
	;;
  esac
fi
CLAIM00PRM=${PARMFILE}
CLAIM00MASN=${OUTFILE}
MSGFILE=${INFOFILE}

export CLAIM00PRM
export CLAIM00MASN
export CLAIM00MASO
export MSGFILE

echo "Convert CLAIM File"
date

if [ ${INTYPE} = "P" ]
then
  echo "   CLAIM00PRM=${CLAIM00PRM}"
else
  echo "RANGE is ${BATCHBEG} to ${BATCHEND}"
fi

echo "   CLAIM00MASO=${CLAIM00MASO}"
echo "   CLAIM00MASN=${CLAIM00MASN}"
if [ ${CREATEORIG} = "Y" ]
then
  echo "   CLAIM00MASORIG=${CLAIM00MASORIG}"
fi
echo "   MSGFILE=${MSGFILE}"

if [ ${SOURCEFILE} = "V" ]
then
  runcobol ${OBJ_DIR}/CLAIMCONVERTRV -a ${INTYPE}${BATCHBEG}${BATCHEND}
else
  runcobol ${OBJ_DIR}/CLAIMCONVERT -c ${RMCONFIG} -a ${INTYPE}${BATCHBEG}${BATCHEND}${CREATEORIG}
fi
RETVAL=$?
date

echo "RETURN_CODE=${RETVAL}"
exit ${RETVAL}
