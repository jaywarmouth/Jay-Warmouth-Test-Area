#!/bin/ksh
#
# Program Name	: rbesi001.sh
# Description   : Create Rebate Summary Report by Carrier, Contract, Group
#                 Command line arguments:
#                 -f Input rebate file name (path hardcoded)
#		  -p <parameter filename>
#		  -o <summary report name>
#
# Author	: Peggy Voytilla
# Date		: 12/31/2014
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
DATETM=`date +%Y%m%d-%H%M%S`
FILE_FLG=0
REPORT_DIR="/usr/lnk/tmp"
RPTNAME_FLG=0

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rbesi001.sh [-f <rebatefile>]

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

# Submit rbesi001 program
submit_rbesi001()
{
   runcobol ${OBJ_DIR}/rbesi001   
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
	FILE_FLG=1
        REBATEFILE=$1
        ;;
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	REBATEPARM=$1
	;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	RPTNAME_FLG=1
	RPTFILE=$1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${FILE_FLG} = 0 ]
then
	usage
fi

export REBATEFILE REBATEPARM



if [ ${RPTNAME_FLG} = 1 ]
then
	REPORTFILE=${RPTFILE}
else
	REPORTFILE=${REPORT_DIR}/RBESI001-SUMMARY-REPORT-${DATETM}.csv
fi
export REPORTFILE

DETAILFILE=${REPORT_DIR}/RBESI001-DETAIL-REPORT-${DATETM}.csv
 export DETAILFILE

echo "Create Rebate Summary Report by Carrier, Contract, Group"
date
echo
echo "REBATEPARM=${REBATEPARM}"
echo "REBATEFILE=${REBATEFILE}"
echo "REPORTFILE=${REPORTFILE}"
echo "DETAILFILE=${DETAILFILE}"
echo

# Submit the program
submit_rbesi001

date

exit 0
