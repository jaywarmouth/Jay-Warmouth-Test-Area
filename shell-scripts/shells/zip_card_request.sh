#!/bin/ksh
#
# Program Name	: zip_card_request.sh
#		  Command Line Arguments:
#		  -p <client transfer directory>
# Description	: zips *MAN.txt files in preparation for download
# Author	: Linda S. Jefferis
# Date		: 04/05/2002
# Modifications : 10/28/2005 - Changes for Linux  (LSJ) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip_card_request.sh -p <client directory>

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
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	TR_DIR=$1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

${ZIP_PROG} -m ${TR_DIR}/MAN.zip ${TR_DIR}/*MAN.txt

exit 0
