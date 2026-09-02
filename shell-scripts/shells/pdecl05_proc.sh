#!/bin/ksh
#       
# Program Name	: pdecl05_proc.sh
# Description   : PDE File Creation
#                 Command line arguments:
#                 -t test mode
#		  -u update mode
#
# Author	: Dawn Engler
# Date		: 09/30/2013
# Modifications : 04/28/2014 change email address from dengler@pdmi.com to operations@pdmi.com
#		
#
# Variables Used:

PDE_DIR=/usr/lnk/pde/in
PDECL05=/usr/lnk/shell/pdecl05.sh
TEST=/usr/lnk/tmp/pdecl05_test
UPDATE=/usr/lnk/tmp/pdecl05_update


# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl05_proc.sh [-t] or [-u]
	-t	No update of PDECL00MAS
	-u	update of PDECL00MAS
**Only run -u if test mode has produced no errors**	
ENDOFUSAGE
  exit 1
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

if [ $# -lt 1 ]
then
	usage
fi

# Run PDECL05 in test mode on all validation files in /usr/lnk/pde/in
if [ "$1" = "-t" ]
then	
	for FILE in $(ls -1 ${PDE_DIR}/RPT.DDPS_TRANS_VALIDATION.*);
	do
		${PDECL05} -t -f ${FILE} >> ${TEST} 2>&1 
	    	mv /usr/lnk/wrk/PDECL05-REPORT-* ${PDE_DIR}
	done
cat ${TEST} | /bin/mail -s "PDECL05 Test" operations@pdmi.com
rm -f ${TEST}
fi        

# Run Update with PDECL05 on all validation files in /usr/lnk/pde/in
if [ "$1" = "-u" ]
then
        for FILE in $(ls -1 ${PDE_DIR}/RPT.DDPS_TRANS_VALIDATION.*);
        do
                ${PDECL05} -f ${FILE} >> ${UPDATE} 2>&1
                mv /usr/lnk/misc/PDECL05-REPORT-* ${PDE_DIR}
        done

cat ${UPDATE} | /bin/mail -s "PDECL05 Update" operations@pdmi.com
rm -f ${UPDATE}
fi

exit 0
