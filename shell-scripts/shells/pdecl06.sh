#!/bin/ksh
# to run: pdecl06.wk -t -f /usr/lnk/shares/wkohuth/RPT.DDPS_P2P_PDE_ACUM_PDP_16146307.txt
#       
#
# Program Name	: pdecl06.sh
# Description   : PDE File Creation
#                 Command line arguments:
#                 -f input file name 
#                 -t test mode
#                 -y year (PDE process year)
# Author	: William Kohuth
# Date		: 02/16/2012
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE="null"
YEAR="9999"
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl06.sh [-t] [-f <input-file>] 


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


# Submit pdecl06 program
submit_pdecl06()
{
     runcobol ${OBJ_DIR}/pdecl06 -s ${TEST_MODE}
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
        FILE=$1
        ;;
    -t) TEST_MODE=1
        ;;
    -y) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        YEAR=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE} = "null" ]
then
  usage
fi


PDEACCUM=${FILE}
export PDEACCUM


echo "PDE Return File Totals - pdecl06"
date
echo "EXPORT PATH:"
echo "   PDEACCUM=$PDEACCUM"
submit_pdecl06 
date

exit 0
