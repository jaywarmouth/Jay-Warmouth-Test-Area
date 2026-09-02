#!/bin/ksh
#
# Program Name  : pdecl02.sh
# Description   : Warehouse PDECL00MAS File Extract
#		  Command Line Arguments:
#		  -i <file path and name>  Assign alternate PDECL00MAS
#		  -o <file path and name>  Assign alternate PDECLRB001
#		  -b <batch range>  e.g. IA01A000LF23Z999
# Author        : James Masluk
# Date          : 12/27/2005
# Modifications : 06/27/2011 - Added "-b" batch range option
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RB_FILE_FLAG=0
PD_FILE_FLAG=0
BATCH_FLG=0
BATCH="00000000"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl02.sh -i <input filename> -o <output filename> -b <Batch Range>
	<input filename>  alt. PDECL00MAS file		optional
	<output filename> alt. PDECLRB001 file		optional
	-b <batch range>   8-char start/end batch	optional
		(If not used, program extracts full file)

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


# Submit pdecl02 program
submit_pdecl02()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/pdecl02 -s ${BATCH_FLG} -a ${BATCH}

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
	PD_FILE_FLAG=1
	PD_FILE=$1
	;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	RB_FILE_FLAG=1
	RB_FILE=$1
	;;
    -b) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	BATCH_FLG=1
	BATCH=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${RB_FILE_FLAG} = 1 ]
then
   PDECLRB001=${RB_FILE}
   export PDECLRB001
fi

if [ ${PD_FILE_FLAG} = 1 ]
then
   PDECL00MAS=${PD_FILE}
   export PDECL00MAS
fi


echo "PDECL00MAS Extract for Warehouse"
echo "     PDECL00MAS=$PDECL00MAS"
echo "     PDECLRB001=$PDECLRB001"
echo "     PDE_BATCH_RANGE=$BATCH"
date
submit_pdecl02
date

exit 0
