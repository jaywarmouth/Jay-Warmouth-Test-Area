#!/bin/sh
# To run: claim137.lc -t -i /usr/lnk/wrk/CLAIM00MAS-LC0521
#
# Program Name	:claim137.lc 
# Description   : UPDATE SELECT CLAIM MASTER FIELDS BASED ON INPUT PARMS
#                 Command line arguments
#                 -i <filename> - assign alternate input file

#                 Switches:
#                 -t Test mode (no CLAIM00MAS file writes)

# Author	: Lucy A. Caraballo 
# Date		: 5/21/2015
# Modifications : 5/25/2015 - changes for production version  (LSJ)
#		: 09/15/2015 - TT:13915-12 - Added if logic for FILE_FLAG 
#		: 05/17/2017 - TT16858-9 (runcobol statement change)
#		: 08/28/2018 - TT18821-1; new error output file logic.
#		: 10/23/2020 - add "-f" logic to specify alt. CLAIM00MAS 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
CLMFILE_FLG=0
DATETM=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim137.sh -i <filename> -o <output file> -r <error file> -t
	-i <filename> is required to provide input filename
	-o <output file> optional CLAIM137UCSV filename
	-r <error file> optional CLAIM137ECSV filename
	-f <clm file> optional assignment of CLAIMS history file
	-t set Test-MODE to ON

ENDOFUSAGE
  exit 99
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

	
# Submit claim137 program
submit_claim137()
{
      runcobol ${OBJ_DIR}/claim137 -a ${TEST_MODE} 
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLMFILE_FLG=1
        CLMFILE=$1
        ;;
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env
  
if [ ${INFILE_FLG} = 1 ]
then
	CLAIM137PRM=$INFILE
else
	usage
fi
export CLAIM137PRM
if [ ${OUTFILE_FLG} = 1 ]
then
        CLAIM137UCSV=$OUTFILE
else
        CLAIM137UCSV=/usr/lnk/wt/oper-wt/CLAIM137UCSV-${DATETM}.csv
fi
export CLAIM137UCSV
if [ ${RPTFILE_FLG} = 1 ]
then
        CLAIM137ECSV=$RPTFILE
else
        CLAIM137ECSV=/usr/lnk/wt/oper-wt/CLAIM137ECSV-${DATETM}.csv
fi
export CLAIM137ECSV

if [ ${CLMFILE_FLG} = 1 ]
then
	CLAIM00MAS=${CLMFILE}
	export CLAIM00MAS
fi

FG4AUD=/usr/lnk/audit/CLAIM02
   export FG4AUD

CLAIM72KEY=${CLAIM72KEY}-CLAIM137
export CLAIM72KEY

echo "UPDATE FIELDS ON CLAIMS MASTER FILE"
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   REVER00MAS=$REVER00MAS"
echo "   CLAIM72KEY=$CLAIM72KEY"
echo "   CLAIM137PRM=$CLAIM137PRM"
echo "   CLAIM137UCSV=$CLAIM137UCSV"
echo "   CLAIM137ECSV=$CLAIM137ECSV"
echo "   FG4AUD=${FG4AUD}" 
submit_claim137
echo "   RET_CODE=$RETVAL "
date

exit $RETVAL
