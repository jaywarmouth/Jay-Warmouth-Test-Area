#!/bin/ksh
#       
# Program Name	: pdecl04_rpts.sh
# Description   : PDE File Creation
#                 Command line arguments:
#                 -t test mode
# Author	: Dawn Engler
# Date		: 09/23/2013
# Modifications : 

# Variables Used:

#FILE="null"
TEST_MODE=0
PDE_DIR=/usr/lnk/pde/in
PDECL04=/usr/lnk/shell/pdecl04.sh

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl04.sh [-t] 
	-t	test mode 	 optional
		(error report writes to alternate directory)

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
for FILE in $(ls -1 ${PDE_DIR}/RPT.DDPS_TRANS_VALIDATION.*);
do
echo ${FILE}
if [ $# -lt 1 ]
then
 	${PDECL04} -f ${FILE}
	rm -f /usr/lnk/misc/PDECL04-TOTALS-*
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
	-t) ${PDECL04} -t -f ${FILE}
            ;;

	-*) usage
	    ;;
    
  esac
  shift
done

done

exit 0
