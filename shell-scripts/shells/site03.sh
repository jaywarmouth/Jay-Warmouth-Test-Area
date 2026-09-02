#!/bin/sh
#
# Program Name	: site03.sh 
# Description   : add, update, or delete records in the SITE000MAS master file  
#                 Command line arguments:
#                 
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

usage: site03.sh [-s ${TEST-MODE}]

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

	
# Submit site03 program
submit_site03()
{
       runcobol ${OBJ_DIR}/site03 -s ${TEST_MODE}${DEBUG_MODE}
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
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        SITE000PRM=$INFILE
else
	usage
fi
export SITE000PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        SITE000UCSV=$OUTFILE
else
        SITE000UCSV=/usr/lnk/wt/oper-wt/SITE000UCSV-${DATETM}.txt
fi
export SITE000UCSV
if [ ${RPTFILE_FLG} = 1 ]
then
        SITE000ECSV=$RPTFILE
else
        SITE000ECSV=/usr/lnk/wt/oper-wt/SITE000ECSV-${DATETM}.txt
fi
export SITE000ECSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   SITE000MAS=$SITE000MAS "
echo "   SITE000PRM=$SITE000PRM "
echo "   FG4AUD=$FG4AUD "
echo "   SITE000UCSV=$SITE000UCSV "
echo "   SITE000ECSV=$SITE000ECSV "
submit_site03
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
