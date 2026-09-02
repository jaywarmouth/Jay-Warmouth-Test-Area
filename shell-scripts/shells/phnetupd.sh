#!/bin/sh
#
# Program Name	: phnetupd.sh 
# Description   : add, update, or delete records in the PHNET00MAS master file  
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

usage: phnetupd.sh 

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

	
# Submit phnetupd program
submit_phnetupd()
{
       runcobol ${OBJ_DIR}/phnetupd -s ${TEST_MODE}${DEBUG_MODE}
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
        PHNETUPDPRM=$INFILE
else
	usage
fi
export PHNETUPDPRM

if [ ${OUTFILE_FLG} = 1 ]
then
        PHNETUPDUCSV=$OUTFILE
else
        PHNETUPDUCSV=/usr/lnk/wt/oper-wt/PHNETUPDUCSV-${DATETM}.csv
fi
export PHNETUPDUCSV
if [ ${RPTFILE_FLG} = 1 ]
then
        PHNETUPDECSV=$RPTFILE
else
        PHNETUPDECSV=/usr/lnk/wt/oper-wt/PHNETUPDECSV-${DATETM}.csv
fi
export PHNETUPDECSV

FG4AUD=$PHAAUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   PHNET00MAS=$PHNET00MAS "
echo "   PHNETUPDPRM=$PHNETUPDPRM "
echo "   FG4AUD=$FG4AUD "
echo "   PHNETUPDUCSV=$PHNETUPDUCSV "
echo "   PHNETUPDECSV=$PHNETUPDECSV "
submit_phnetupd
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
