#!/bin/sh
#
# Program Name	: rbadmld01.sh 
# Description   : add, update, or delete records in the RBADM00MAS master file  
#                 
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

usage: rbadmld01.sh 

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

	
# Submit rbadmld01 program
submit_rbadmld01()
{
       runcobol ${OBJ_DIR}/rbadmld01 -s ${TEST_MODE}${DEBUG_MODE}
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
  esac
  shift
done
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        RBADMBPRM=$INFILE
else
	usage
fi
export RBADMBPRM

if [ ${OUTFILE_FLG} = 1 ]
then
        RBADMU02CSV=$OUTFILE
else
        RBADMU02CSV=/usr/lnk/wt/oper-wt/RBADMU02CSV-${DATETM}.csv
fi
export RBADMU02CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        RBADME02CSV=$RPTFILE
else
        RBADME02CSV=/usr/lnk/wt/oper-wt/RBADME02CSV-${DATETM}.csv
fi
export RBADME02CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   RBADM00MAS=$RBADM00MAS "
echo "   RBADMBPRM=$RBADMBPRM "
echo "   FG4AUD=$FG4AUD "
echo "   RBADMU02CSV=$RBADMU02CSV "
echo "   RBADME02CSV=$RBADME02CSV "
submit_rbadmld01
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
