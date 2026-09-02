#!/bin/sh
#
# Program Name  : drprc01.sh
# Description   : Warehouse DRGPRC0MAS File Extract
#		  Command Line Arguments:
#                 -f Complete update(Full-Run)
#		  -o <alt. output file name>
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FULL_RUN=0
FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drprc01.sh [-f] [-o <filename>]

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


# Submit drprc01 program
submit_drprc01()
{
        runcobol ${OBJ_DIR}/drprc01 -s ${FULL_RUN} 
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) FULL_RUN=1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        OUTPUT_FILE=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
        DRGPRCRB001=${OUTPUT_FILE}
        export DRGPRCRB001
fi

echo "DRGPRC0MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   DRGPRC0MAS=${DRGPRC0MAS}"
echo "   DRGPRCRB001=${DRGPRCRB001}"
submit_drprc01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
