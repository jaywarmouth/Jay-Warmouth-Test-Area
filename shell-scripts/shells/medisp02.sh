#!/bin/sh
#
# Program Name	: medisp02.sh 
# Description   : Undate indexed file MODIF00MAS from a sequential file
#                 Command Line Options:
#                 -o <alt MED02CSV filename>
#                       Default is: /usr/lnk/misc/MED02CSV.csv
#                 
# Author	: Lucy A. Caraballo
# Date		: 02/10/2017
# Modifications : 02/23/2017 - updates for production version.
#		: 
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

usage: medisp02.sh 

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

	
# Submit medisp02 program
submit_medisp02()
{
      runcobol ${OBJ_DIR}/medisp02
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
        MED02CSV=$OUTFILE
else
        MED02CSV=/usr/lnk/misc/MED02CSV.csv
fi
export MED02CSV


echo UPDATE MODIF00MAS FROM A SEQ FILE
date
echo "EXPORT PATHS:"
echo "   MODIF00MAS=$MODIF00MAS "
echo "   MDDBMOD=$MDDBMOD "
echo "   FG4AUD=$FG4AUD "
echo "   MED02CSV=$MED02CSV "

submit_medisp02
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
