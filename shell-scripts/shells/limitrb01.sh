#!/bin/sh
#
# Program Name	:limitrb01.sh
# Description   : EXTRACT LIMIT RECORDS BASED ON A PARAMETER FILE.        
#                 Command line arguments
#                 Switches:
#                 -t Test mode
#		  -i <LIMWHSEP parameter filename>	optional
#		  -o <LIMPCEXTR filename>	optional
# Author	: Debbe A. Adgate   
# Date		: 3/7/2016 
# Modifications : 5/2/2016 - updates for production version of script TT3200-51.
#		: 5/26/2016 - TT13915-26
#		: 6/2/2016 - TT13915-26 Correction to allow process to run in crontab and JAMS since large file being created.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INFILE_FLAG=0
OUTFILE_FLAG=0
TEST_MODE=0
RETVAL=0
PATH=/usr/rmcobol:$PATH

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limitrb01.sh [-t] -i <parameter filename> -o <LIMPCEXTR output filename>
	all arguments are optional

ENDOFUSAGE
  exit 1
}


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

	
# Submit verifyfl program
submit_limitrb01()
{
      runcobol ${OBJ_DIR}/limitrb01 -C /opt/rmcobol/terminfo-d0.cfg -s ${TEST_MODE} 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	INFILE_FLAG=1
	PARMFILE=$1
	;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	OUTFILE_FLAG=1
	FILE=$1
	;;
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

if [ $INFILE_FLAG = 1 ]
then
	LIMWHSEP=$PARMFILE
	export LIMWHSEP
fi

if [ $OUTFILE_FLAG = 1 ]
then
	LIMPCEXTR=$FILE
else
	LIMPCEXTR=${HOME}/LIMPCEXTR
fi
export LIMPCEXTR

echo "EXTRACT LIMIT RECORDS FOR WAREHOUSE"                   
date
echo "EXPORT PATHS:"
echo "   LIMWHSEP=$LIMWHSEP"
echo "   LIMWHSEE=$LIMWHSEE"
echo "   LIMPCEXTR=$LIMPCEXTR"
echo "   LIMIT00MAS=$LIMIT00MAS"
echo "   CARDH00MAS=$CARDH00MAS"
submit_limitrb01   
date

exit $RETVAL
