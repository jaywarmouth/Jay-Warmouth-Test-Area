#!/bin/sh
#
# Program Name	: onetmup01.sh 
# Description   : add, update, or delete records in the ONETM00MAS master file  
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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: onetmup01.sh -i <ONETM01PRM input file> -o <ONETM0U01CSV output file> -r <ONETM0E01CSV error file>

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

	
# Submit onetmup01 program
submit_onetmup01()
{
       runcobol ${OBJ_DIR}/onetmup01
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
        ONETM01PRM=$INFILE
else
	usage
fi
export ONETM01PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        ONETM0U01CSV=$OUTFILE
else
        ONETM0U01CSV=/usr/lnk/wt/oper-wt/ONETM0U01CSV-${DATETM}.csv
fi
export ONETM0U01CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        ONETM0E01CSV=$RPTFILE
else
        ONETM0E01CSV=/usr/lnk/wt/oper-wt/ONETM0E01CSV-${DATETM}.csv
fi
export ONETM0E01CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "" 
echo "SERVER=${HOSTNAME}"
echo "EXPORT PATHS:"
echo "   ONETM00MAS=$ONETM00MAS "
echo "   ONETM01PRM=$ONETM01PRM "
echo "   FG4AUD=$FG4AUD "
echo "   ONETM0U01CSV=$ONETM0U01CSV "
echo "   ONETM0E01CSV=$ONETM0E01CSV "
submit_onetmup01
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
