#!/bin/ksh
#
# This program is designed to create a comma delimted report from the PDE Master
# 
# Program Name	: pdecl12.sh
# Description   : Create PDE Report for QA
#                 Command line arguments:
#                 -i <PDECL12PARM input file>
#                 -o <PDECLRPT output file>
# Author	: Peggy Voytilla
# Date		: 10/24/2016

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INFILE_FLAG=0
OUTFILE_FLAG=0
RETVAL=0
DATETM=`date +%Y%m%d-%H%M%S`
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl12.sh -i <PDECL12PARM input file> -o <PDECLRPT output file> 

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


# Submit pdecl12 program
submit_pdecl12()
{
     runcobol ${OBJ_DIR}/pdecl12  
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
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INFILE_FLAG=1
        INFILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLAG=1
        OUTFILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $INFILE_FLAG = 1 ]
then
        PDECL12PARM=$INFILE
else
        PDECL12PARM=/usr/lnk/wt/oper-wt/misc/PDECL12PARM.txt
fi
export PDECL12PARM

if [ $OUTFILE_FLAG = 1 ]
then
        PDECLRPT=$OUTFILE
else
        PDECLRPT=/usr/lnk/wt/oper-wt/misc/PDECLRPT-${DATETM}.txt
fi
export PDECLRPT

echo "PDECL00MAS REPORT EXTRACT"
date
echo "   PDECL00MAS=$PDECL00MAS"
echo "   PDECL12PARM=$PDECL12PARM"
echo "   PDECLRPT=$PDECLRPT"

submit_pdecl12 
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
