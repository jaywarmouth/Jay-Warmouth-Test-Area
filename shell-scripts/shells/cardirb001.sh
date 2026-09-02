#!/bin/ksh
#
# Program Name  : cardirb001.sh 
# Description   : UPDATE CARDI00MAS MASTER FILE TO REDBRICK
#                 Command Line Arguments:
#                 -d Date Range (Beginning date-Ending date ccyymmddccyymmdd) 
#                 -o <filename> - alternate output file name (optional)
#		  -z sample/demo flag
# Author        : Jim Masluk
# Date          : 05/02/2001
# Modifications : 01/18/2008 - Added "-o" option  (LSJ)
#	
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
DATE_RANGE="null"
SAMP_FLAG=0
OUTPUT_FILE="null"
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardirb001.sh [-d ccyymmddccyymmdd] [-o <filename>]
	-o <filename>	optional

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


# Submit cardirb001 
submit_cardirb001()
{

     runcobol ${OBJ_DIR}/cardirb001 -a ${DATE_RANGE}  

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE_RANGE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        OUTPUT_FILE=$1
        ;;
    -z) SAMP_FLAG=1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${SAMP_FLAG} = 1 ]
then
        ENV_FILE="/usr/lnk/demo/env_var.demo"
        parse_env
fi
if [ ${FILE_FLAG} = 1 ]
then
   CARDIRBMAS=${OUTPUT_FILE}
   export CARDIRBMAS
fi

echo "CARDI00MAS FILE EXTRACT for REDBRICK"
echo ""

date
echo "EXPORT PATHS:"
echo "   CARDIRBMAS=${CARDIRBMAS}"
echo ""
submit_cardirb001 
date

exit 0
