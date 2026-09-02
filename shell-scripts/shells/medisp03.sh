#!/bin/sh
#
# Program Name	: medisp03.sh 
# Description   : Update/Add GENER00MAS records using DRUG000MAS TypeCode=1
#                 Command Line Options:
#                 -o <alt MED03CSV filename>
#                       Default is: /usr/lnk/misc/MED03CSV.csv
#                 
# Author	: Lucy A. Caraballo
# Date		: 02/13/2017
# Modifications : 02/23/2017 - updates for production version. 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
OUTFILE_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: medisp03.sh 

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

	
# Submit medisp03 program
submit_medisp03()
{
      runcobol ${OBJ_DIR}/medisp03
}      

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        OUTFILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $OUTFILE_FLG = 1 ]
then
        MED03CSV=$OUTFILE
else
        MED03CSV=/usr/lnk/misc/MED03CSV.csv
fi
export MED03CSV

echo UPDATE GENER00MAS FROM THE DRUG FILE
date
echo "EXPORT PATHS:"
echo "   GENER00MAS=$GENER00MAS "
echo "   DRUG000MAS=$DRUG000MAS "
echo "   FG4AUD=$FG4AUD "
echo "   MED03CSV=$MED03CSV "

submit_medisp03
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
