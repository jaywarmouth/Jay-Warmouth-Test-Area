#!/bin/ksh
#
# Program Name  : arlimitlif.sh
# Description   : Lifetime Limit extract procedure    
#		  Reads a Limit Archive file (program variable - LIMIT00MAS)
#		  Writes records to LIMIT output file (Program variable - LIMITARMAS).
# 		Command Line Arguments:
#                 -c A|E - function code; A-Archive, E-Extract
#			For this one-time use of this, will use the "A" code.
#		  -i <input LIMIT filename> 
#			Required. For this program this is a Limit archive file.
#		  -f <LIMITARMAS filename>
#			For this program this is a LIMIT Work file.
#		  -p <GRPLIFELIM parameter filename>
#			optional - default is /usr/lnk/log/GRPLIFELIM.txt
#                 -o <LIMCSVOUT1 filename>
#			optional - default is /usr/lnk/wrk/LIMCSVOUT1
#                 -t test mode            
# Author        : Linda Jefferis
# Date          : 06/06/2017
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FUNC_CODE="null"
TEST_MODE=0
PFILE_FLG=0
DATE=`date +%Y%m%d%H%M$S`
INFILE_FLG=0
CSVFILE_FLG=0
CSVFILE="null"
OUTFILE_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: arlimitlif.sh [-t test_mode] [-c <A|E>] [-i <inout LIMIT filename>] [-f <LIMITARMAS filename>] [-p <GRPLIFELIM filename]
	The -c and -i options are REQUIRED
	The -t, -o, -f, and -p options are optional

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

#
# Validate -c options
validate_code()
{  case ${FUNC_CODE} in
     "A" | "E")
         ;;
     *)  usage
         ;;
   esac
}


# Submit arlimitlif program
submit_arlimitlif()
{
        runcobol ${OBJ_DIR}/arlimitlif -a ${FUNC_CODE}${TEST_MODE}
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FUNC_CODE=$1
	validate_code
        ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INFILE=$1
	INFILE_FLG=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE=$1
	OUTFILE_FLG=1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	CSVFILE_FLG=1
        CSVFILE=$1
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	PFILE_FLG=1
        FILE=$1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${FUNC_CODE} = "null" ]
then
        usage
fi
if [ ${INFILE_FLG} = 0 ]
then
	usage
else
	LIMIT00MAS=${INFILE}
	export LIMIT00MAS
fi


# This is ONLY opened if doing running as A-Archive option
FG4AUD=/usr/files/misc/LIMAUD-arlimitlif-${DATE}
   export  FG4AUD

if [ $PFILE_FLG = 1 ]
then
	GRPLIFELIM=$FILE
else
	GRPLIFELIM=/usr/lnk/log/GRPLIFELIM.txt
fi
export GRPLIFELIM
if [ $OUTFILE_FLG = 1 ]
then
	LIMITARMAS=$OUTFILE
else
	LIMITARMAS=/usr/files/misc/LIMITWRK-${DATE}
fi
export LIMITARMAS
if [ $CSVFILE_FLG = 1 ]
then
	LIMCSVOUT1=$CSVFILE
else
	LIMCSVOUT1=/usr/lnk/wrk/LIMCSVOUT1.csv
fi
export LIMCSVOUT1


date
echo "EXTRACT LIFETIME LIMIT RECORDS FROM ARCHIVE"
echo ""
echo "EXPORT FILES:"
echo "     FG4AUD=$FG4AUD"
echo "     LIMIT00MAS=$LIMIT00MAS"
echo "     LIMITARMAS=$LIMITARMAS"
echo "     GRPLIFELIM=$GRPLIFELIM"
echo "     LIMCSVOUT1=$LIMCSVOUT1"
echo ""
submit_arlimitlif
date

exit ${RETVAL}
