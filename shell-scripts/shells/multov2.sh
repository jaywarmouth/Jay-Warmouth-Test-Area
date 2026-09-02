#!/bin/sh
#
# Program Name	: multov2.sh 
# Description   : add, update, or delete records in the MULTOV0MAS master file  
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

usage: multov2.sh -i <MULTOV2PRM input file> -o <MULTOVU02CSV output file> -r <MULTOVE02CSV error file>

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

	
# Submit multov2 program
submit_multov2()
{
       runcobol ${OBJ_DIR}/multov2 -s ${TEST}${DEBUG}
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
        MULTOV2PRM=$INFILE
else
	usage
fi
export MULTOV2PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        MULTOVU02CSV=$OUTFILE
else
        MULTOVU02CSV=/usr/lnk/wt/oper-wt/MULTOVU02CSV-${DATETM}.csv
fi
export MULTOVU02CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        MULTOVE02CSV=$RPTFILE
else
        MULTOVE02CSV=/usr/lnk/wt/oper-wt/MULTOVE02CSV-${DATETM}.csv
fi
export MULTOVE02CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   MULTOV0MAS=$MULTOV0MAS "
echo "   MULTOV2PRM=$MULTOV2PRM "
echo "   FG4AUD=$FG4AUD "
echo "   MULTOVU02CSV=$MULTOVU02CSV "
echo "   MULTOVE02CSV=$MULTOVE02CSV "
submit_multov2
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
