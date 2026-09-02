#!/bin/bash
#
#
# Program Name	: stcfg02.sh

# Description   : add, update, or delete records in the STCFG00MAS file  
#                 Command line arguments:
#                 
# Date		: 03/19/2024
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
RETVAL=0
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: stcfg02.sh [-s ${TEST-MODE}]

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

	
# Submit stcfg02 program
submit_stcfg02()
{

       runcobol ${OBJ_DIR}/stcfg02 -s ${TEST_MODE}${DEBUG_MODE}                      
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
    -s) TEST_MODE=1
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
if [ ${INFILE_FLG} = 1 ]
then
        STCFG02PRM=$INFILE
else
        usage
fi
export STCFG02PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        STCFGU02CSV=$OUTFILE
else
        STCFGU02CSV=/usr/lnk/wt/oper-wt/STCFGU02CSV-${DATETM}.csv
fi
export STCFGU02CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        STCFGE02CSV=$RPTFILE
else
        STCFGE02CSV=/usr/lnk/wt/oper-wt/STCFGE02CSV-${DATETM}.csv
fi
export STCFGE02CSV

FG4AUD=${GRPAUD}
   export FG4AUD

date
echo "EXPORT PATHS:"

echo "   STCFG02PRM=$STCFG02PRM "
echo "   STCFG00MAS=$STCFG00MAS "
echo "   FG4AUD=$FG4AUD "
echo "   STCFGU02CSV=$STCFGU02CSV "
echo "   STCFGE02CSV=$STCFGE02CSV "
submit_stcfg02
echo  "   RET_CODE=$RETVAL "
date


exit 0
