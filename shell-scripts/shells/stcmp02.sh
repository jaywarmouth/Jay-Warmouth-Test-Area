#!/bin/sh
#
#
# Program Name	: stcmp02.sh 

# Description   : add, update, or delete records in the STCOMP0MAS master file  
#                 Command line arguments:
#                 
#                 
# Author	: murbanek
# Date		: 9/11/2019
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
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: stcmp02.sh [-s ${TEST-MODE}]

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

	
# Submit stcmp02 program
submit_stcmp02()
{

       runcobol ${OBJ_DIR}/stcmp02 -s ${TEST_MODE}${DEBUG_MODE} 
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
        STCMP02PRM=${INFILE}
else
        usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        STCMP02UCSV=${OUTFILE}
else
        STCMP02UCSV=/usr/lnk/wt/oper-wt/STCMP02UCSV-${DATETM}.csv
fi

if [ $RPTFILE_FLG = 1 ]
then
        STCMP02ECSV=${RPTFILE}
else
        STCMP02ECSV=/usr/lnk/wt/oper-wt/STCMP02ECSV-${DATETM}.csv
fi

export STCMP02PRM STCMP02UCSV STCMP02ECSV

FG4AUD=$FG4AUD
  export FG4AUD


date
echo "EXPORT PATHS:"
echo "   STCOMP0MAS=$STCOMP0MAS "
echo "   STCMP02PRM=$STCMP02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   STCMP02UCSV=$STCMP02UCSV "
echo "   STCMP02ECSV=$STCMP02ECSV "
submit_stcmp02
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
