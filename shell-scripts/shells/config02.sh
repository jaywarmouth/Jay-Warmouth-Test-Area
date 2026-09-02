#!/bin/sh
#
# Program Name	: config02.sh 
# Description   : Update/Add CONFIG0MAS records using input parameter text file.
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

usage: config02.sh -t -d -f <input file> -o <output file> -r <ErrorReport file>
        -t              - flag to not update CONFIG0MAS
        -f <file>       - required, input filename
        -o <file>       - optional, CONFIGU02CSV name, default is
                          /usr/lnk/wt/oper-wt/CONFIGU02CSV-datetm.txt
        -r <file>       - optional, CONFIGE02CSV filename, default is
                          /usr/lnk/wt/oper-wt/CONFIGE02CSV-datetm.txt

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

	
# Submit config02 program
submit_config02()
{
       runcobol ${OBJ_DIR}/config02 -s ${TEST_MODE}${DEBUG_MODE}
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
        CONFIG02PRM=${INFILE}
else
	usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        CONFIGU02CSV=${OUTFILE}
else
        CONFIGU02CSV=/usr/lnk/wt/oper-wt/CONFIGU02CSV-${DATETM}.txt
fi

if [ $RPTFILE_FLG = 1 ]
then
        CONFIGE02CSV=${RPTFILE}
else
        CONFIGE02CSV=/usr/lnk/wt/oper-wt/CONFIGE02CSV-${DATETM}.txt
fi

export CONFIG02PRM CONFIGU02CSV CONFIGE02CSV

FG4AUD=$GRPAUD  
  export FG4AUD

date
echo "EXPORT PATHS:"
echo "   CONFIG0MAS=$CONFIG0MAS "
echo "   CONFIG02PRM=$CONFIG02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   CONFIGU02CSV=$CONFIGU02CSV "
echo "   CONFIGE02CSV=$CONFIGE02CSV "
submit_config02
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
