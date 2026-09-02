#!/bin/sh
#
# Program Name	: stept001.sh 
# Description   : add, update, or delete records in the STEPT00MAS master file  
#                 
#                 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`
TEST=0
DEBUG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: stept001.sh -i <STEPT01PRM input file> -o <STEPT0U01CSV output file> -r <STEPT0E01CSV error file>

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

	
# Submit stept001 program
submit_stept001()
{
       runcobol ${OBJ_DIR}/stept001 -s ${TEST}${DEBUG}
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
  esac
  shift
done
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        STEPT01PRM=$INFILE
else
	usage
fi
export STEPT01PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        STEPT0U01CSV=$OUTFILE
else
        STEPT0U01CSV=/usr/lnk/wt/oper-wt/STEPT0U01CSV-${DATETM}.csv
fi
export STEPT0U01CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        STEPT0E01CSV=$RPTFILE
else
        STEPT0E01CSV=/usr/lnk/wt/oper-wt/STEPT0E01CSV-${DATETM}.csv
fi
export STEPT0E01CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   STEPT00MAS=$STEPT00MAS "
echo "   STEPT01PRM=$STEPT01PRM "
echo "   FG4AUD=$FG4AUD "
echo "   STEPT0U01CSV=$STEPT0U01CSV "
echo "   STEPT0E01CSV=$STEPT0E01CSV "
submit_stept001
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
