#!/bin/ksh
#
# This program is designed to create a comma delimted report from the MDGAP Master
# 
# Program Name	: mdgap02.sh
# Description   : Create MDGAP ReportL
#                 Command line arguments:
#                 -i <MDGAPPARM input file>
#                 -o <MDGAPRPT output file>
# Author	: Peggy Voytilla
# Date		: 09/21/2016
# Modifications : 10/14/2016 - Changes for production version (LSJ)

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

usage: mdgap02.sh -i <MDGAPPARM input file> -o <MDGAPRPT output file> 

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


# Submit mdgap02 program
submit_mdgap02()
{
     runcobol ${OBJ_DIR}/mdgap02  
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
        MDGAPPARM=$INFILE
else
        MDGAPPARM=/usr/lnk/wt/oper-wt/misc/MDGAPPARM.txt
fi
export MDGAPPARM

if [ $OUTFILE_FLAG = 1 ]
then
        MDGAPRPT=$OUTFILE
else
        MDGAPRPT=/usr/lnk/wt/oper-wt/misc/MDGAPRPT-${DATETM}.txt
fi
export MDGAPRPT

echo "MDGAP00MAS REPORT EXTRACT"
date
echo "   MDGAP00MAS=$MDGAP00MAS"
echo "   MDGAPPARM=$MDGAPPARM"
echo "   MDGAPRPT=$MDGAPRPT"

submit_mdgap02 
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
