#!/bin/sh
#
# Program Name	: medisp01.sh 
# Description   : Update indexed file NDCMO00MAS from a sequential file
#		  Command Line Options:
#		  -o <alt MED01CSV filename>
#			Default is: /usr/lnk/misc/MED01CSV.csv
#                 
# Author	: Lucy A. Caraballo
# Date		: 02/06/2017
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

usage: medisp01.sh

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

	
# Submit medisp01 program
submit_medisp01()
{
      runcobol ${OBJ_DIR}/medisp01
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
	MED01CSV=$OUTFILE
else
	MED01CSV=/usr/lnk/misc/MED01CSV.csv
fi
export MED01CSV

echo UPDATE NDCMO00MAS FROM A SEQ FILE
echo "HOSTNAME=$HOSTNAME"
date
echo "EXPORT PATHS:"
echo "   NDCMO00MAS=$NDCMO00MAS "
echo "   MDDBNMOD=$MDDBNMOD "
echo "   FG4AUD=$FG4AUD "
echo "   MED01CSV=$MED01CSV "

submit_medisp01
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
