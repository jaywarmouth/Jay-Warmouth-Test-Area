#!/bin/ksh
#
# Program Name	: zip-reb12.sh
# Description	: Zips the rebate12 files
#		  Command Line Arguments:
#		  -d <mmddccyy> - month ending date
# Author	: Linda S. Jefferis
# Date		: 03/15/2002
# Modifications : 03/18/2005 - Newcycle changes for filename  (LSJ) 
#		: 10/24/2005 - Changes for Linux  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
ZIP_PROG="/usr/local/bin/zipit"
PASSWORD="rb12esi"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="179"
TMP_FILE="/tmp/tmp_lst"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-reb12.sh -d <m/e date - mmddccyy>

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

ZIP_FILE=RB12_${DATE}.zip
ZIP_OPTS="+e ${PASSWORD} +o "-m""

cd ${PO_DIR}
find sys?? -name "???RB12??A-P.PCX" -print > ${TMP_FILE}
for FILE in `cat ${TMP_FILE}`
do
	NAME=`echo $FILE | cut -c10-20`
	${CONV_PROG} ${REC_LEN} $FILE ${NAME}
	${ZIP_PROG} ${ZIP_OPTS} ${ZIP_FILE} ${NAME}
done

rm ${TMP_FILE}

# Parse environment variables
#parse_env

exit 0
