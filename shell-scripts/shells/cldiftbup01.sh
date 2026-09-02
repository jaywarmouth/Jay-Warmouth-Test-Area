#!/bin/sh
#
# Program Name	: cldiftbup01.sh 
# Description   : Update Differentials (by calling C5sub_prcadmin) in CLAIM00MAS records provided by CLAIMKEYS in input parameter file.
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INFILE_FLG=0
OUTFILE_FLG=0
TEST_MODE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cldiftbup01.sh -t -f <input file> -o <output file>
	 -t              - flag to not update CLAIM00MAS
        -i <file>       - required, input filename
        -o <file>       - optional, CLDIFTBUP01CSV name, default is
                          /usr/lnk/tmp/CLDIFTBUP01CSV-datetm.txt

ENDOFUSAGE
  exit 1
}


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

	
# Submit cldiftbup01 program
submit_cldiftbup01()
{
      runcobol ${OBJ_DIR}/cldiftbup01 -s ${TEST_MODE} 
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
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

FG4AUD=/usr/lnk/audit/CLAIM02
  export FG4AUD
         
if [ $INFILE_FLG = 1 ]
then
	CLDIFTBUP01PRM=$INFILE
else
	usage
fi
export CLDIFTBUP01PRM

if [ $OUTFILE_FLG = 1 ]
then
	CLDIFTBUP01CSV=$OUTFILE
else
	CLDIFTBUP01CSV=/usr/lnk/tmp/CLDIFTBUP01CSV-${DATETM}.csv
fi
export CLDIFTBUP01CSV

CYCLERRS=/usr/lnk/audit/CYCLERRS_traffic_MAN.csv; export CYCLERRS

   echo "Update Differentials in CLAIM00MAS File"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   CLAIM00MAS=$CLAIM00MAS"
   echo "   SPONS00MAS=$SPONS00MAS"
   echo "   SYSTE00MAS=$SYSTE00MAS"
   echo "   CLDIFTBUP01PRM=$CLDIFTBUP01PRM"
   echo "   CLDIFTBUP01CSV=$CLDIFTBUP01CSV" 
   submit_cldiftbup01
   date

echo "RET_CODE=$RETVAL"
exit $RETVAL
