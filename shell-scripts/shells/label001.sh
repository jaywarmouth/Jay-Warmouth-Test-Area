#!/bin/ksh
#
# Compare CMS downloaded label file with Label Master File (LABEL00MAS)
#
# Program Name  : label001.sh
# Description   : Compare CMS downloaded label file with Label Master File (LABEL00MAS)
#                 Command line arguments:
#		  -i <LABELTRAN input filename>
#                 -f <LBLREPORT filename>  - filename of CMS text file
#                
# Author        : Peggy Voytilla
# Date          : 07/21/2016
# Modifications :
#               :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
INFILE_FLAG=0
OUTFILE_FLAG=0
OBJ_DIR="/usr/lnk/obj"
FILE_NAME="null"
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: label001.sh [-i <filename>] [-f <filename>] 

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

# Submit label001 program
submit_label001()
{
        runcobol ${OBJ_DIR}/label001
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
    -f) shift
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
        LABELTRAN=$INFILE
else
	LABELTRAN=/usr/lnk/wt/oper-wt/misc/LABELTRAN.txt
fi
export LABELTRAN

if [ $OUTFILE_FLAG = 1 ]
then
        LBLREPORT=$OUTFILE
else
	LBLREPORT=/usr/lnk/wt/oper-wt/misc/LABEL001-COMPARE-REPORT-${DATETM}.txt
fi
export LBLREPORT


date
echo ""
echo "   LABELTRAN=$LABELTRAN"
echo "   LABEL00MAS=$LABEL00MAS"
echo "   LBLREPORT=$LBLREPORT"
echo ""
submit_label001
date

exit $RETVAL

