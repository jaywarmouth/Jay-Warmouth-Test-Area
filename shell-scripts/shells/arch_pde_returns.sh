#!/bin/ksh
#
# Program Name	: arch_pde_returns.sh
# Description	: Archive specified files
# Author	: Dawn Engler
# Date		: 09/12/2013
#
#Modifications	: 10/03/2013 - Add logic to remove PDECL05-REPORT-* files that are moved into /usr/lnk/pde/in for verification purposes (DME)
#		: 01/12/2015 - Add coding to check for Archive directory. If not there create directory. (DME)
#
#
# Variables Used:
YEAR=`date +%Y`
PDE_DIR="/usr/lnk/pde/in"
ARCH_DIR="/usr/lnk/pde/in/${YEAR}"


#
# Main routine
#
#Check for Archive Directory
if ! test -d ${ARCH_DIR}
then
	mkdir -m 770 ${ARCH_DIR}
fi

FILE=""
	
for FILE in $(ls -1 ${PDE_DIR}/RPT.DDPS_ERROR_SUMMARY.* ${PDE_DIR}/RPT.DDPS_TRANS_VALIDATION.* ${PDE_DIR}/RSP.PDFS_RESP.*);
do
	if test -s ${FILE}
	then
		echo "--> Moving ${FILE} to ${ARCH_DIR}"
		mv ${FILE} ${ARCH_DIR}
		if test $? -ne 0
		then
			echo "-*> Problem with copying ${FILE}..."
			echo "-*> Fix before running additional 340b Physician Processes"
			exit 1
		fi
	else
		echo "--*> The file ${FILE} does not exist."
	fi
done
 
rm -f ${PDE_DIR}/PDECL05-REPORT-*

exit 0
