#!/bin/ksh
#
#
# Program Name	: binchk02.sh

# Description   : add, update, or delete records in the BINCHK0MAS file  
#                 Command line arguments:
#	       -i <file>       - required, input  filename
#	       -o <file>       - optional, output filename
#	       -r <file>       - optional, error filename
#	       -t              - optional, test mode      
#	       -u              - optional, debug mode     
#                 
# Date		: 03/18/2025
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
DEBUG_MODE=0
INFILE_FLAG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: binchk02.sh -t ${TEST_MODE} -d ${DEBUG_MODE} -i <input_file>

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
	
# Submit binchk02 program
submit_binchk02()
{
       runcobol ${OBJ_DIR}/binchk02  -s ${TEST_MODE}${DEBUG_MODE}    
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
        INFILE_FLG=1
        INFILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        OUTFILE=$1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RPTFILE_FLG=1
        RPTFILE=$1
        ;;
    -t) TEST_MODE=1
       ;;
    -d) DEBUG_MODE=1
       ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${INFILE_FLG} = 1 ]
then
        BINCHK02PRM=${INFILE}
else
	usage
fi
export BINCHK02PRM

FG4AUD=$FG4AUD
   export FG4AUD
 
if [ ${OUTFILE_FLG} = 1 ]
then
        BINCHKU02CSV=$OUTFILE
else
        BINCHKU02CSV=/usr/lnk/wt/oper-wt/BINCHKU02CSV-${DATETM}.CSV
fi
export BINCHKU02CSV

if [ ${RPTFILE_FLG} = 1 ]
then
        BINCHKE02CSV=$RPTFILE
else
        BINCHKE02CSV=/usr/lnk/wt/oper-wt/BINCHKE02CSV-${DATETM}.CSV
fi
export BINCHKE02CSV

date
echo "EXPORT PATHS:"

echo "   BINCHK02PRM =$BINCHK02PRM "
echo "   BINCHK0MAS  =$BINCHK0MAS "
echo "   FG4AUD      =$FG4AUD "
echo "   BINCHKU02CSV=$BINCHKU02CSV "
echo "   BINCHKE02CSV=$BINCHKE02CSV "
submit_binchk02
echo  "   RET_CODE=   $RETVAL "
date


exit $RETVAL
