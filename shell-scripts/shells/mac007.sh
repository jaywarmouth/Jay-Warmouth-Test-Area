#!/bin/ksh
#
#
# Program Name	: mac007.sh 
# Description   : Unload indexed file mac0000MAS to a sequential file
#                 Command line arguments:
#   		  -i <Parm filename>              
#			optional - default is /usr/lnk/wt/oper-wt/MAC00PRM.txt
#                 -o <MAC00CSV filename> 
#			optional - default is /usr/lnk/wt/benefit-wt/MacTableUpdates/MAC00CSV-${DATETM}.txt
# Author	: Debbe Adgate 
# Date		: 06/16/2016
# Modifications : 6/23/2016 - TT15561-5 - Changes/Additions for produciton version of script           
#		: 10/12/2016 - Fix missing "#" comment designation on line 10 and default MAC00CSV directory.

#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
DATETM=`date +%Y%m%d%H%M%S`
FILE_FLAG=0
OUTFILE_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mac007.sh -t -i <MAC00PRM filename> -o <MAC00CSV filename>

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

	
# Submit mac007 program
submit_mac007()
{
      runcobol ${OBJ_DIR}/mac007 -s $TEST_MODE
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
        FILE_FLAG=1
        FILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        OUTFILE=$1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=$FG4AUD
  export FG4AUD

if [ ${FILE_FLAG} = 1 ]
then
        MAC00PRM=${FILE}
else
        MAC00PRM=/usr/lnk/wt/oper-wt/MAC00PRM.txt
fi
export MAC00PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        MAC00CSV=${OUTFILE}
else
        MAC00CSV=/usr/lnk/wt/benefit-wt/MacTableUpdates/MAC00CSV-${DATETM}.txt
fi
export MAC00CSV


echo UNLOAD MAC0000MAS TO A SEQ FILE
date
echo "EXPORT PATHS:"
echo "   MAC0000MAS=$MAC0000MAS "
echo "   MAC00PRM=$MAC00PRM "
echo "   FG4AUD=$FG4AUD "
echo "   MAC00CSV=$MAC00CSV "

submit_mac007
echo  "RETVAL=$RETVAL "
date


exit $RETVAL
