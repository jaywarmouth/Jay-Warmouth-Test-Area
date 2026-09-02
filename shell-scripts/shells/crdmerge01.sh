#!/bin/ksh
#
# Program Name  : crdmerge01.sh
# Description   : CRDAUD File Update Process
#		  Command Line Arguments:
#                 -e End of Day
#                 -r <file date-mmddyy>
#                 -t Test Mode
#
# Author        : James Masluk
# Date          : 02/16/2006
# Modifications : 05/19/2006 - Put in logic for alt. file when -e is set  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
END_DAY=0
RERUN=0
FILE_DATE="null"
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: crdmerge01.sh [-e ] [-r] [-t]
        -e end day flag     Run end of day procedure
        -r <mmddyy>    file date for rerun (optional)
        -t test mode
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

#
# Submit crdmerge01 program
submit_crdmerge01()
{
     runcobol ${OBJ_DIR}/crdmerge01 -s ${END_DAY}${RERUN}${TEST_MODE} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -e) END_DAY=1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1
        FILE_DATE=$1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${END_DAY} = 1 ]
then
   CRDAUD0CUR=${CRDAUD0CUR}-END
fi
if [ ${RERUN} = 1 ]
then
   CRDAUD=${CRDAUD}.${FILE_DATE}
   CRDAUDFG=${CRDAUDFG}.${FILE_DATE}
   CRDAUDRT=${CRDAUDRT}.${FILE_DATE}
fi

if [ ${TEST_MODE} = 1 ]
then
   CRDAUD0CTL=/usr/lnk/wrk/CRDAUD0CTL
     export CRDAUD0CTL

   CRDAUD0CUR=/usr/lnk/wrk/CRDAUD0CUR
     export CRDAUD0CUR
fi

echo "CRDAUD File Update Process"
echo "EXPORT PATHS:"
echo "   CRDAUD0CTL=$CRDAUD0CTL"
echo "   CRDAUD0CUR=$CRDAUD0CUR"
echo "   CRDAUD=$CRDAUD"
echo "   CRDAUDFG=$CRDAUDFG"
echo "   CRDAUDRT=$CRDAUDRT"
date
submit_crdmerge01 
date

exit 0
