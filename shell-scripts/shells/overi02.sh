#!/bin/sh
# 
# Program Name	: overi02.sh
# Description   : Create transition overrides
#                 Command line arguments:
#                 -f input transaction file name
#		  -o OVERI00WRK filename
#		  -r OVREPORT filename
#                 -t test-mode

# Author	: Peggy Voytilla
# Date		: 11/18/2016
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
TEST_MODE=0
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: OVERI02.sh -t -f <input file> -o <OVERI00WRK file> -r <OVREPORT file>
	-t		- flag to not update OVERI00MAS
	-f <file>	- required, input filename
	-o <file>	- optional, OVERI00WRK name, default is 
			  /usr/lnk/tmp/OVERI00WRK-datetm
	-r <file>	- optional, OVREPORT filename, default is
			  /usr/lnk/tmp/OVERI02-REPORT-datetm.csv

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


# Submit overi02 program
submit_overi02()
{
     runcobol ${OBJ_DIR}/overi02 -s ${TEST_MODE} 
     RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
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
	OVERI02TRN=${INFILE}
else
	usage
fi

if [ $OUTFILE_FLG = 1 ]
then
	OVERI00WRK=${OUTFILE}
else
	OVERI00WRK=/usr/lnk/tmp/OVERI00WRK-${DATETM}
fi

if [ $RPTFILE_FLG = 1 ]
then
	OVREPORT=${RPTFILE}
else
	OVREPORT=/usr/lnk/tmp/OVERI02-REPORT-${DATETM}.csv
fi

export OVREPORT OVERI00WRK OVERI02TRN

echo "Create Overrides for Transition"
date
echo "   OVERI02TRN=$OVERI02TRN"
echo "   CARDH00MAS=$CARDH00MAS"
echo "   OVERI00MAS=$OVERI00MAS"
echo "   OVERI00WRK=$OVERI00WRK"
echo "   OVREPORT=$OVREPORT"
submit_overi02 
date

exit $RETVAL
