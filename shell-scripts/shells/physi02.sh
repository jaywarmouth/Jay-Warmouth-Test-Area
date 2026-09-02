#!/bin/sh
#
# Program Name	: physi02.sh 
# Description   : Update/Add PHYSI00MAS records using input parameter text file.
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

usage: physi02.sh -t -d -f <input file> -o <output file> -r <ErrorReport file>
        -t              - flag to not update PHYSI00MAS
        -f <file>       - required, input filename
        -o <file>       - optional
        -r <file>       - optional

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

	
# Submit physi02 program
submit_physi02()
{
       runcobol ${OBJ_DIR}/physi02 -s ${TEST_MODE}${DEBUG_MODE}        
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
    -t) TEST_MODE=1
       ;;
    -d) DEBUG_MODE=1
       ;;
    -f) shift
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


 
#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        PHYSI02PRM=${INFILE}
else
	usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        PHYSIU02CSV=${OUTFILE}
else
        PHYSIU02CSV=/usr/lnk/wt/oper-wt/PHYSIU02CSV-${DATETM}.csv
fi

if [ $RPTFILE_FLG = 1 ]
then
        PHYSIE02CSV=${RPTFILE}
else
        PHYSIE02CSV=/usr/lnk/wt/oper-wt/PHYSIE02CSV-${DATETM}.csv
fi

export PHYSI02PRM PHYSIU02CSV PHYSIE02CSV

FG4AUD=$CRDAUD  
  export FG4AUD

date
echo "EXPORT PATHS:"
echo "   PHYSI00MAS=$PHYSI00MAS "
echo "   PHYSI02PRM=$PHYSI02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   PHYSIU02CSV=$PHYSIU02CSV "
echo "   PHYSIE02CSV=$PHYSIE02CSV "
submit_physi02
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
