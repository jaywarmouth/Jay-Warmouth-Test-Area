#!/bin/sh
#
# Program Name	: rm-calmon.sh
# Description	: Remove calendar month files
#                 Command line arguments:
# Author	: Linda S. Jefferis
# Date		: 08/09/2005
# Modifications : 07/06/2006 - Removed references to claim112 files  (LSJ)
#		: 08/17/2006 - Added claim106 files  (LSJ)
#		: 09/28/2006 - Added "-follow" find commands  (LSJ)
#		: 10/16/2006 - Changed find command for PCX files  (LSJ)
#		: 05/17/2007 - Added files for claim171  (LSJ)
#		: 12/10/2007 - Added INLGWRK files  (LSJ)
#		: 10/08/2008 - Changed names for claim106 related files  (LSJ)
#		: 06/30/2009 - Changes for "W" claim106 files  (LSJ)
#		: 04/-5/2011 - Added medco rebate files
#		: 07/08/2013 - Removed inactives
#		: 09/19/2013 - Removed rebate files
#		: 09/29/2014 - logic for tweek "X" files (TT #11688-3)
#		: 03/03/2016 - logic for week "W" files
#               : 01/03/2018 - TT:1730-57; remove logic for tweek files.
#               : 1/17/2018 - TT1730-58; remove "pay" logic.
#               : 02/02/2018 - TT18170-2; add "tweek" logic back.
#		: 02/08/2021 - Remove cardh08 process
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
RPT_DIR="/usr/lnk/rpt"
KEY_DIR="/usr/lnk/keys"
GRP_DIR="/usr/upd/grp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-calmon.sh 

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


# Parse environment variables
parse_env

cd ${PO_DIR}
find . -follow -name "*CA07?-X*" -exec rm {} \;
find . -follow -name "*CA07?-T*" -exec rm {} \;

rm ${KEY_DIR}/CARDH07KEY.cm*

rm ${GRP_DIR}/INLGWRKMAS-CRDS-?

rm ${RPT_DIR}/cmon-*

exit 0
