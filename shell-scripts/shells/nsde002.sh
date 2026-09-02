#!/bin/sh
#
# Program Name	: nsde002.sh
# Description   : Unlock records on NDCLOCK file based on NSDE file
#                 Command line arguments
#                 -i <filename> - assign alternate NSDE input file

#                 Switches:
#                 -t Test mode (no NDCLOCK file rewrites)

# Author	: Dave Rudawsky 
# Date		: 10/06/2014
# Modifications :  
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILEDIR=/usr/lnk/tmp
FILE_FLAG=0
TEST_MODE=0
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nsde002.sh [-i <filename>] [-t]
	-i <filename> is optional to provide input filename

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

	
# Submit nsde002 program
submit_nsde002()
{
      runcobol ${OBJ_DIR}/nsde002 -s ${TEST_MODE}  
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
	FILE_FLAG=1
	FILE=$1
	;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

if [ $FILE_FLAG = 1 ]
then
	NSDE000MAS=$FILE
fi
export NSDE000MAS

NSDE002CSV=/usr/lnk/misc/NSDE002RPT-${DATE}.csv
export NSDE002CSV

   echo "NSDE002 Process"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   NDCLOCKMAS=$NDCLOCKMAS"
   echo "   NSDE000MAS=$NSDE000MAS"
   echo "   NSDE002CSV=$NSDE002CSV"
   
   submit_nsde002
   date

exit 0
