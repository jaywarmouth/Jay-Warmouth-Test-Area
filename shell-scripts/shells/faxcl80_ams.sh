#!/bin/ksh
#
# Program Name	: faxcl80_ams.sh
# Description	: Procedure to fax the Claim80 report to Ameriscript
#		  Command Line Arguments:
#		  -d <ccyymmdd>  Date of file
# Author	: Linda S. Jefferis
# Date		: 10/26/1998
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
FAX_TO="Michelle Swigonski"
PHONE="13306867011"
FILE_DIR="/usr/ncr3525/tmp/cla80-dir"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: faxcl80_ams.sh -d <ccyymmdd>

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
        DATE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

if [ ${DATE} = "null" ]
then
  usage
else
  fax "${FAX_TO}" ${FILE_DIR}/${DATE}.ams ${PHONE} 132
fi

exit 0
