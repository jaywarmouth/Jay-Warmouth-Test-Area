#!/bin/ksh
#
# Program Name	: npicms01.sh
# Description   : NPICMS0MAS extract to warehouse.
#                 Command line arguments:
#                 -f Complete update(Full-Run)
#		  -o <filename> Assign alternate output NPICMSRB001 file name
# Author	: Mike Paulus
# Date		: 01/30/2008
# Modifications : 07/02/2010 - Added logic for dated file and clientfiles location.                         
#		: 01/13/2011 - Removed "STORM" logic
#		: 04/26/2013 - Removed logic for dating and transferring file
#		: 06/22/2016 - Change to RUNTYPE logic
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
RUNTYPE=P
FILE_FLAG=0
OUTPUT_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: npicms01.sh [-f] [-o <filename>]

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

# Submit npicms01 program
submit_npicms01()
{
     runcobol ${OBJ_DIR}/npicms01 -a ${RUNTYPE}   
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) RUNTYPE=F
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	OUTPUT_FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
   	NPICMSRB001=${OUTPUT_FILE}
fi
export NPICMSRB001

echo "Extract of NPICMS0MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   NPICMSRB001=${NPICMSRB001}"
echo "   RUNTYPE=$RUNTYPE"
submit_npicms01
date

exit 0
