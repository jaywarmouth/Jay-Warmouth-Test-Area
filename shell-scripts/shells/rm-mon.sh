#!/bin/ksh
#
# Program Name	: rm-mon.sh
# Description	: Remove mon-cycle files
#                 Command line arguments:
#                 -p <p/e prefix> (e.g. I30)
# Author	: Linda S. Jefferis
# Date		: 09/25/98
# Modifications : 10/26/2000 - Added po/misc/LIMINVFILE file  (LSJ) 
#		: 11/14/2000 - Added -p command line argument  (LSJ)
#		: 11/14/2000 - Added remove of ???LTRINV  (LSJ)
#		: 07/03/2001 - Took out CLAIM94KEY (LSJ)
#		: 03/20/2002 - Added remove of rebate12 files  (LSJ)
#		: 06/07/2002 - Added remove of rebate13 files  (LSJ)
#		: 10/01/2003 - Added remove of mon- rpt files  (LSJ)
#		: 04/06/2004 - Moved rebate12 and rebate13 files to calendar month procedures  (LSJ)
#		: 06/24/2004 - Added remove of CLWRK00MED file  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-mon.sh -p <p/e prefix>

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
find . -name "*CL13*" -exec rm {} \;
find . -name "*CL11*" -exec rm {} \;
find . -name "*CL32*" -exec rm {} \;
find . -name "*CL34*" -exec rm {} \;
find . -name "*CL36*" -exec rm {} \;
find . -name "*CL38*" -exec rm {} \;
find . -name "*CL39*" -exec rm {} \;
find . -name "*CL57*" -exec rm {} \;
find . -name "*CA07*" -exec rm {} \;
find . -name "*CA08*" -exec rm {} \;
find . -name "*LTRINV*" -exec rm {} \;
find misc -name "${PREFIX}LIMINVFILE" -exec rm {} \;

rm ${CLAIM11KEY}
rm ${CLAIM13KEY}.*
rm ${CLAIM31KEY}
rm ${CARDH07KEY}
rm ${CLAIM32KEY}
rm ${CLAIM38KEY}.*
rm ${CLAIM56KEY}
rm ${CLAIM34KEY}
rm ${CLAIM71KEY}

rm ${CLAIM31MAS}
rm /usr/lnk/claims/CLWRK00MED

rm ${RPT_DIR}/mon-*

exit 0
