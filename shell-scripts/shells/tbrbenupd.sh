#!/bin/sh
#
# Program Name	: tbrbenupd.sh 
# Description   : add, update, or delete records in the TBRBEN0MAS master file  
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

usage: tbrbenupd.sh [-s ${TEST-MODE}]

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

	
# Submit tbrbenupd program
submit_tbrbenupd()
{
       runcobol ${OBJ_DIR}/tbrbenupd -s ${TEST_MODE}${DEBUG_MODE}
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
        TBRBEUPDPRM=$INFILE
else
	usage
fi
export TBRBEUPDPRM

if [ ${OUTFILE_FLG} = 1 ]
then
        TBRBEUPDUCSV=$OUTFILE
else
        TBRBEUPDUCSV=/usr/lnk/wt/oper-wt/TBRBEUPDUCSV-${DATETM}.csv
fi
export TBRBEUPDUCSV
if [ ${RPTFILE_FLG} = 1 ]
then
        TBRBEUPDECSV=$RPTFILE
else
        TBRBEUPDECSV=/usr/lnk/wt/oper-wt/TBRBEUPDECSV-${DATETM}.csv
fi
export TBRBEUPDECSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   TBRBEN0MAS=$TBRBEN0MAS "
echo "   TBRBEUPDPRM=$TBRBEUPDPRM "
echo "   FG4AUD=$FG4AUD "
echo "   TBRBEUPDUCSV=$TBRBEUPDUCSV "
echo "   TBRBEUPDECSV=$TBRBEUPDECSV "
submit_tbrbenupd
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
