#!/bin/ksh
#
# Program Name	: onetm001.sh
# Description   : ONETM00MAS extract to warehouse.
#                 Command line arguments:
#                -d <date modified range>
#                   to run onetm001.sh -d ALL     - FOR ALL RECORDS
#                          onetm001.sh -d CCYYMMDDCCYYMMDD
#                -o <alt ONETMRB001 filename>
# Date		: 06/23/2017
# Modifications :                                                            
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
OUTFILE_FLG=0
DATE_RANGE="null"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: onetm001.sh -d <date-range> -o <ONETMRB001 name>
	date-range: ALL or yyyymmddyyyymmdd	REQUIRED
	ONETMRB001 name				OPTIONAL

ENDOFUSAGE
  exit 99
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
	  echo "*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit onetm001 program	
submit_onetm001()
{
     runcobol ${OBJ_DIR}/onetm001 -a ${DATE_RANGE}  
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
	OUTFILE_FLG=1
	OUTFILE=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${DATE_RANGE} = "null" ]
then
	usage
fi
if [ ${OUTFILE_FLG} = 1 ]
then
	ONETMRB001=${OUTFILE}
	export ONETMRB001
fi


echo "Extract of ONETM00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   ONETMRB001=${ONETMRB001}"
echo "   ONETM0MAS=${ONETM00MAS}"
submit_onetm001
echo  "   RETVAL=$RETVAL "
date

exit ${RETVAL}

