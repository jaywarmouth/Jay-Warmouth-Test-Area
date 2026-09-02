#!/bin/ksh
#
# Program Name	: rm-qrt.sh
# Description	: Remove mon-cycle files
# Author	: Linda S. Jefferis
# Date		: 09/25/98
# Modifications : 10/19/2004 - Addition of claim122 and rebate15 files  (LSJ) 
#		: 10/14/2005 - Removed claim122 files  (LSJ)
#		: 10/14/2005 - Changed RB15 file name  (LSJ)
#		: 04/24/2006 - Added remove of qrt-* in rpt directory  (LSJ)
#		: 05/15/2007 - Added claim109en files  (LSJ)
#		: 10/11/2007 - Name change to ENNI-Q-TEXT  (LSJ)
#		: 02/21/2008 - Removed files related to claim109en; this process is no longer run (Ennis terminated)  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
TAPE_DIR="/usr/lnk/tapes"
MISC_DIR="/usr/lnk/misc"
KEY_DIR="/usr/lnk/keys"
CLM_DIR="/usr/upd/claims"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-qrt.sh 

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
find . -name "*CL19*" -exec rm {} \;
find . -name "*CL29*" -exec rm {} \;
find . -name "*CL33*" -exec rm {} \;

rm $CLAIM29KEY
rm $REBATE15KEY
rm ${KEY_DIR}/CLAIM114KEY

rm $CLAIM33MAS
rm $CLAIM33MAS.???
rm $CLAIM29MAS
rm $CLM_DIR/CLAIM19MAS.qua

cd $TAPE_DIR
rm ???RB15-O-QCP

cd $MISC_DIR
rm CLAIM114-RPT.*

cd $RPT_DIR
rm qrt-*

exit 0
