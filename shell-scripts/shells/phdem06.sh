#!/bin/sh
#
# Program Name	: phdem06.sh 
# Description   : add, update, or delete records in the PHDEM06MAS master file  
#                 Command line arguments:
#                 
#                 
# Author	: Patrick Murphy
# Date		: 03/20/2025
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE="N"
DEBUG_MODE="N"
RETVAL=0
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phdem06.sh [-i ${input_file} -o ${output_file} -r ${report_file} -s ${TEST-MODE}${DEBUG-MODE}]

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

	
# Submit phdem06 program
submit_phdem06()
{
       runcobol ${OBJ_DIR}/phdem06 -a ${TEST_MODE}${DEBUG_MODE} 
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
        PHDEM06PRM=$INFILE
else
	usage
fi
export PHDEM06PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        PHDEMU06CSV=$OUTFILE
else
        PHDEMU06CSV=/usr/lnk/wt/oper-wt/PHDEMU06CSV-${DATETM}.txt
fi
export PHDEMU06CSV

if [ ${RPTFILE_FLG} = 1 ]
then
        PHDEME06CSV=$RPTFILE
else
        PHDEME06CSV=/usr/lnk/wt/oper-wt/PHDEME06CSV-${DATETM}.txt
fi
export PHDEME06CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   PHDEM06PRM=$PHDEM06PRM "
echo "   PHDEM00MAS=$PHDEM00MAS "
echo "   FG4AUD=$FG4AUD "
echo "   PHDEMU06CSV=$PHDEMU06CSV "
echo "   PHDEME06CSV=$PHDEME06CSV "
submit_phdem06
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
