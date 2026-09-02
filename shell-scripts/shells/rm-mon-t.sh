#!/bin/ksh
#
# Program Name	: rm-mon-t.sh
# Description	: Remove mon-cycle files
#                 Command line arguments:
#                 -p <p/e prefix> (e.g. I30)
# Author	: Linda S. Jefferis
# Date		: 02/09/2005
# Modifications : 06/08/2005 - Addition of CLAIM71KEY  (LSJ) 
#		: 08/09/2005 - Addition of MEDI tape files  (LSJ)
#		: 09/28/2006 - Added "-follow" to find commands  (LSJ)
#		: 09/28/2006 - removed claim71 files  (LSJ)
#		: 07/06/2007 - removed unused logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
RPT_DIR="/usr/lnk/rpt"
KEY_DIR="/usr/lnk/keys"
TAPE_DIR="/usr/lnk/tapes"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-mon-t.sh -p <p/e prefix>

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
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PREFIX=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

cd ${PO_DIR}
find . -follow -name "*CL39?-T*" -exec rm {} \;
find . -follow -name "*CL57?-T*" -exec rm {} \;
find . -follow -name "*LTRINV*" -exec rm {} \;
find misc -name "${PREFIX}LIMINVFILE-T" -exec rm {} \;

rm ${KEY_DIR}/*.mtwice*
rm ${CLAIM56KEY}-T


rm ${RPT_DIR}/mon-t-*

exit 0
