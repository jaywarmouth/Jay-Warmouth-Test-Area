#!/bin/ksh
#
# Program Name	: drug036.sh
#                 Command line arguments:
#                 -i Alternate Input Filename (MI MEDICAID filename)
#		  -x Report only switch
# Description   : DRUG000MAS Type Code 50 Update                    
# Author	: Debbie Wilson          
# Date		: 11/29/99
# Variables Used:
# Modifications : 02/07/2000 - Added "Report only switch" logic

ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
REPORT=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug036.sh [-i <filename>] [-x]

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

# Submit drug036 program
submit_drug036()
{
        runcobol ${OBJ_DIR}/drug036 -s ${REPORT}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
   case "$1"
   in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INPUT_FILE=$1
	FILE_FLAG=1
        ;;
    -x) REPORT=1
	;;
   esac
   shift
done


# Parse environment variables
parse_env

# Assign other variables
if [ ${FILE_FLAG} = 1 ]
then
  DRGMI00MAS=${INPUT_FILE}
  export DRGMI00MAS
fi

echo "MI Medicaid Type Code 50 Update"         
date
echo "EXPORT PATHS:"
echo "   DRGMI00MAS=$DRGMI00MAS"

submit_drug036
date

exit 0
