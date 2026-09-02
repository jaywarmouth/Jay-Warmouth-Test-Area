#!/bin/sh
#
# Program Name	: mbi_input.sh
# Description	: Processes the input file from MBI (Akron General).
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file sent.
# Author	: Linda S. Jefferis
# Date		: 02/23/2007
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
FILE_DIR="/usr/lnk/shares/ftp-tmp"
OUT_FILE="/usr/upd/crd_01/CARDH0AGMC"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mbi_input.sh [-d <ccyymmdd>]

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

#
# Set Filenames
set_filename()
{
        PGP_FILE="80-${DATE}.exp.pgp"
	IN_FILE="80-${DATE}.exp"
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
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
	set_filename
        ;;
  esac
  shift
done

if [ ${DATE} = "null" ]
then
   usage
fi

mv ${FILE_DIR}/${IN_FILE} ${OUT_FILE}
if test $? -ne 0
then
	echo "-*> Error moving file..."
	exit 1
else
	echo "--> File from MBI has been moved to ${OUT_FILE}"
	echo "--> Removing PGP file..."
	rm -f ${FILE_DIR}/${PGP_FILE}
fi

exit 0
