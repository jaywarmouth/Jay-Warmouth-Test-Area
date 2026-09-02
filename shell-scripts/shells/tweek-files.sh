#!/bin/sh
#
# Program Name	: tweek-files.sh
# Description	: tweek-cycle file creation procedures
# Author	: Linda S. Jefferis
# Date		: 10/09/2010
# Modifications : 11/04/2010 - Changes for NEW tweek cycle
#		: 07/18/2011 - Add claim83ghc process
#		: 10/01/2011 - Add email and PDF logic
#		: 03/13/2012 - Changed claim09 to claim109d0
#		: 07/29/2013 - Add claim111d0 process
#		: 05/27/2014 - Add EOM claim109pro process
#		: 06/20/2016 - TT15288-48 clmrt01 procedure
#		: 1/9/2018 - TT17821-4; removal of PRAT related procedures.
#		: 4/5/2018 - TT17486-54; Changes for AHF termination
#		: 07/03/2018 - Additional removals for AHF terminations.
#		: 11/12/2019 - Change "a2ps" to "enscript"
#		: 01/24/2020 - Remove claim111d0 process
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tweek-files.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/clmrt01.sh -c tweek -v > ${RPT_DIR}/tweek-clmrt01 2>&1

# Convert output files to PDF and email
echo "### tweek-clmrt01 ###" >> ${RPT_DIR}/tweek-tweek-files
cat ${RPT_DIR}/tweek-clmrt01 >> ${RPT_DIR}/tweek-tweek-files


enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/tweek-tweek-files | ps2pdf - ${RPT_DIR}/tweek-tweek-files.pdf

echo "Output from tweek-files.sh process" | ${MAIL_PROG} -s "TWeek-cycle - tweek-files" ${MAIL_TO} -a ${RPT_DIR}/tweek-tweek-files.pdf 

exit 0
