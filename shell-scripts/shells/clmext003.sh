#!/bin/sh
#
# Program Name	: clmext003.cbl
# Description   : CREATE CSV REPORT OF CLAIM00MAS FILE
#                 Command line arguments:
#                  
#                 -r is used to pass batch ranges.
#                  this program can be run in the following modes.
#                       1) with all A's starting parameter (export entire file)        
#                               eg. clmext003.sh -r AAAAAAAAAAAAAA
#                       2) with -r <startbatchclaim> (export from starting batch/claim to end of file)
#                               eg. clmext003.sh -r UA01V001000001
#                       3) with -r <startbatchclaim><endbatchclaim> (export from starting batch/claim to ending batch/claim)       
#                               eg. clmext003.sh -r UA01V001000001UA01V001000050
#		  -i <alt input CLAIM00MAS>
#		  -o <alt output CSV file>
# Author	: Peggy Voytilla
# Date		: 03/24/2021
# Modifications : 
#
#   
# 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
DATETM=`date +%Y%m%d%H%M%S`
BATCH_RANGE="AAAAAAAAAAAAAA"
INFILE_FLG=0
OUTFILE_FLG=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmext003.sh [-r <linkage data>] -i <claim file> -o <output CSV file>

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."
}

# Submit clmext003 program
submit_clmext003()
{
         runcobol ${OBJ_DIR}/clmext003 -a ${BATCH_RANGE}
 
}

#
# Main routine
#

#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCH_RANGE=$1
        ;;
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        INFILE=$1
	INFILE_FLG=1
        ;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE=$1
	OUTFILE_FLG=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env


# Assign alternate environment variable

if [ ${INFILE_FLG} = 1 ]
then
	CLAIM00MAS=${INFILE}; export CLAIM00MAS
fi
if [ ${OUTFILE_FLG} = 1 ]
then
	CLAIMEXTCSV=${OUTFILE}
else
	CLAIMEXTCSV=${HOME}/CLAIMEXTCSV-${DATETM}.csv
fi
export CLAIMEXTCSV

date
submit_clmext003 

exit 0
