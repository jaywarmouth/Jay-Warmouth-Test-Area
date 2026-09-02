#!/bin/sh
#
#
# Program Name	: brrej02.sh 

# Description   : add, update, or delete records in the BROPREJMAS master file  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
DEBUG_MODE=0
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: brrej02.sh [-s ${TEST-MODE}]

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

	
# Submit brrej02 program
submit_brrej02()
{

       runcobol ${OBJ_DIR}/brrej02 -s ${TEST_MODE}${DEBUG_MODE} 
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
        BRREJ02PRM=${INFILE}
else
        usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        BRREJ02UCSV=${OUTFILE}
else
        BRREJ02UCSV=/usr/lnk/wt/oper-wt/BRREJ02UCSV-${DATETM}.csv
fi

if [ $RPTFILE_FLG = 1 ]
then
        BRREJ02ECSV=${RPTFILE}
else
        BRREJ02ECSV=/usr/lnk/wt/oper-wt/BRREJ02ECSV-${DATETM}.csv
fi

export BRREJ02PRM BRREJ02UCSV BRREJ02ECSV

FG4AUD=$FG4AUD
  export FG4AUD


date
echo "EXPORT PATHS:"
echo "   BROPREJMAS=$BROPREJMAS "
echo "   BRREJ02PRM=$BRREJ02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   BRREJ02UCSV=$BRREJ02UCSV "
echo "   BRREJ02ECSV=$BRREJ02ECSV "
submit_brrej02
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
