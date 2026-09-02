#!/bin/ksh
#
# Program Name	: odohs1.sh
# Description   : Monthly ODOHS Update 
#                 Command line argument:
#                 -d <current date - yymmdd>
# Author	: Linda S. Jefferis
# Date		: 12/17/96
# Modifications : 04/16/97 Removed drug017.sh from run  (LSJ)
#                 04/16/97 Removed proc_audit  (LSJ)
#                 08/14/97 Change RUNPATH to find file in MEDISPAN (CMH)
#                 09/23/97 Added drug021.sh  (LSJ)
#		  03/15/00 Removed drug017 runs  (LSJ)
#		  03/15/00 Added drug037 and drug038 runs  (LSJ)
#		  03/16/00 Removed drug021  (LSJ)
#		  09/20/00 Added odohs05  (LSJ)
#		  09/21/00 Removed date logic  (LSJ)
#		  09/29/00 Removed drug037  (LSJ)
#		  10/13/00 Removed drug038  (LSJ)
#		  12/29/00 Fixed lpp of drug017.0415 to drug017.0415od  (LSJ)
#		  01/17/01 Added printing of /usr/pdm/po/misc/PRINT-ODOHS04-TEMP  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
PRT_DIR="/usr/lnk/po/misc"
PRT_ODOHS05="${PRT_DIR}/PRINT-ODOHS05"
PRT_ODOHS04="${PRT_DIR}/PRINT-ODOHS04-TEMP"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: odohs1.sh  

ENDOFUSAGE
  exit 1
}


#
# Main routine
#
# Check command line validity, call usage if incorrect

rm -f ${PRT_ODOHS05}
${SHELL_DIR}/odohs05.sh > ${RPT_DIR}/odohs05 2>&1
if test -f ${PRT_ODOHS05}
then
   lpp ${RPT_DIR}/odohs05
   if test -s ${PRT_ODOHS05}
   then
     	 lpp ${PRT_ODOHS05}
   else
     	 echo "*-> ${PRT_ODOHS05} is zero or doesn't exist"
   fi
   rm -f ${PRT_ODOHS04}
   ${SHELL_DIR}/odohs04.sh > ${RPT_DIR}/odohs04 2>&1
   lpp ${RPT_DIR}/odohs04
   if test -s ${PRT_ODOHS04}
   then
	lpp ${PRT_ODOHS04}
   else
	echo "*-> ${PRT_ODOHS04} is zero or doesn't exist"
   fi
   ${SHELL_DIR}/drug017.sh -p -t "0415" > ${RPT_DIR}/drug017.0415od 2>&1
   lpp ${RPT_DIR}/drug017.0415od
else
   echo "*-> odohs05 may have not run correctly"
   echo "*-> therefore did not let updates run"
   exit 1
fi

exit 0
