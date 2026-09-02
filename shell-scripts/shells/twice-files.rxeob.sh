#!/bin/sh
#
# Program Name	: twice-files.sh
# Description	: Twice-cycle file creation procedures
# Author	: Linda S. Jefferis
# Date		: 01/28/05
# Modifications : 05/31/2005 - Addition of claim111 for RXEOB  (LSJ)
#		: 10/07/2005 - Switch from claim178 to clmrt01 procedure  (LSJ)
#		: 01/17/2006 - Removed lp od the rpt files  (LSJ)
#		: 03/09/2006 - Addition of claim109.sh  (LSJ)
#		: 12/28/2007 - Added claim111rx.sh  (LSJ)
#		: 03/06/2009 - Added claim109qtm.sh  (LSJ)
#		: 05/01/2009 - Moved clmrt01 to end  (LSJ)
#		: 11/18/2010 - Changes for move of AHF to tweek-cycle
#		: 12/08/2011 - Added PDF logic
#		: 12/16/2011 - As per InforMed email, no longer need claim130 process for WCHP file
#		: 12/28/2011 - Added claim111d0 process
#		: 01/05/2011 - Changed claim109 to claim109d0 and removed claim111
#		: 01/22/2013 - Added claim111rx (for ApproRx)
#		: 11/1/2013 - Added claim130 (for ApproRx select groups)
#		: 02/03/2014 - removed claim109qtm process (sys0116 termed)
#               : 06/27/2014 - Add "-v" option to always create version 5010 formatted files instead of using entry in OUTDEM
#		: 1/1/2015 - removal of ODMH claim109do process; client terminated.
#		: 05/12/2015 - Add claim109d0 (TT:13528-1)
#		: 07/17/2018 - Removal of claim109d0 
#		: 02/18/2019 - TT18858-47; addtion of claim109gran logic.
#		: 11/12/2019 - Change "a2ps" to "enscript"
#		: 02/17/2025 - Removed "now inactive" claim130.sh and claim109gran.sh processes.
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
MAIL_TO=operations@pdmi.com
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice-files.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim111rx.sh -c twice > ${RPT_DIR}/twice-claim111rx 2>&1

# Convert output files to PDF and email
echo "### twice-claim111rx ###" > ${RPT_DIR}/twice-twice-rxeob-files
cat ${RPT_DIR}/twice-claim111rx >> ${RPT_DIR}/twice-twice-rxeob-files

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/twice-twice-rxeob-files | ps2pdf - ${RPT_DIR}/twice-twice-rxeob-files.pdf

echo "Output from twice-files.rxeob.sh process" | ${MAIL_PROG} -s "twice-cycle - twice-rxeob-files" ${MAIL_TO} -a ${RPT_DIR}/twice-twice-rxeob-files.pdf 

exit 0
