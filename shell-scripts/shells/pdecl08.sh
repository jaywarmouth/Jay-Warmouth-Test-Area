#!/bin/ksh
#
# This program is designed to convert the PDE return file to Excel.
#
# Can be used with input file that contains multiple return files combined.
# 
# Program Name	: pdecl08.sh
# Description   : PDE Return File Convert to EXCEL
#                 Command line arguments:
#                 -i input file name
#		  -o output report name
# Author	: Peggy Voytilla
# Date		: 01/07/2014
# Modifications : 03/20/2017 - updates for prod version  (LSJ)

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_IN="null"
FILE_OUT="null"
DATETM=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl08.sh -i <PDERETRURN file> -o <PDEREPORT file>

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


# Submit pdecl08 program
submit_pdecl08()
{
     runcobol ${OBJ_DIR}/pdecl08  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 4 ]
then
        usage
        exit 1
fi
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then 
          usage
        fi
        FILE_IN=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then 
          usage
        fi
        FILE_OUT=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_IN} = "null" ]
then
  usage
else
 PDERETURN=${FILE_IN}
  export PDERETURN
fi

if [ ${FILE_OUT} = "null" ]
then
  usage
else
  PDEREPORT=${FILE_OUT}.csv
  export PDEREPORT
fi

echo "PDE Submission/Return File Convert to EXCEL"
date
echo "   PDERETURN=$PDERETURN"
echo "   PDEREPORT=$PDEREPORT"
submit_pdecl08 
date

exit 0
