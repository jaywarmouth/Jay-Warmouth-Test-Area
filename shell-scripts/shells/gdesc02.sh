#!/bin/sh
#
# Program Name	: gdesc02.sh 
# Description   : add, update, or delete records in the GDESC00MAS master file  
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

usage: gdesc02.sh -i <GDESC02PRM input file> -o <GDESCU02CSV output file> -r <GDESCE02CSV error file>

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

	
# Submit gdesc02 program
submit_gdesc02()
{
       runcobol ${OBJ_DIR}/gdesc02 -s ${TEST}${DEBUG}
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
        GDESC02PRM=$INFILE
else
	usage
fi
export GDESC02PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        GDESCU02CSV=$OUTFILE
else
        GDESCU02CSV=/usr/lnk/wt/oper-wt/GDESCU02CSV-${DATETM}.csv
fi
export GDESCU02CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        GDESCE02CSV=$RPTFILE
else
        GDESCE02CSV=/usr/lnk/wt/oper-wt/GDESCE02CSV-${DATETM}.csv
fi
export GDESCE02CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   GDESC00MAS=$GDESC00MAS "
echo "   GDESC02PRM=$GDESC02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   GDESCU02CSV=$GDESCU02CSV "
echo "   GDESCE02CSV=$GDESCE02CSV "
submit_gdesc02
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
