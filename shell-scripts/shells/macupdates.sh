#!/bin/sh
#
# Program Name	: macupdates.sh
# Description   : On Demand MAC updates 
#                 Command Line Argument:
# Author	: Linda S. Jefferis
# Date		: 02/06/2015
# Modifications : 06/25/2015 - Updated archive process (TT:13915-2)
#
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
RPT_DIR_2="/usr/lnk/misc"
MAIL_TO="Benefits@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
MAC0000MAS="/usr/lnk/drug/MAC0000MAS"
ARCH="husk:/usr/lnk/rptarch/macupdates"
DATE=`date +%Y%m%d`
MACUPD_DIR="/usr/lnk/wt/pharmacy-wt/macupdates/updresults"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: macupdates.sh 

ENDOFUSAGE
  exit 1
}


# Process rpt reports
process_rpt()
{
	enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/mac006 | ps2pdf - ${MACUPD_DIR}/mac006-${DATE}.pdf
	enscript -rgj --non-printable-format=space -a2- -o - ${RPT_DIR_2}/MAC006_PRTRPT | ps2pdf - ${MACUPD_DIR}/MAC006_PRTRPT-${DATE}.pdf
	enscript -rgj --non-printable-format=space -a2- -o - ${RPT_DIR_2}/MAC006_ERRRPT | ps2pdf - ${MACUPD_DIR}/MAC006_ERRRPT-${DATE}.pdf
	if test -s ${RPT_DIR_2}/MAC006_MACLOCKUPD.txt
	then
		cp ${RPT_DIR_2}/MAC006_MACLOCKUPD.txt ${MACUPD_DIR}/MAC006_MACLOCKUPD-${DATE}.txt
	fi
	
}

#
# Archival
archive()
{
	zip -jm /tmp/macupdate-${DATE}.zip ${RPT_DIR}/mac006 ${RPT_DIR_2}/MAC006_PRTRPT ${RPT_DIR_2}/MAC006_ERRRPT ${RPT_DIR_2}/MAC006_MACLOCKUPD.txt ${MAC0000MAS}.${DATE}*
	zip -j /tmp/macupdate-${DATE}.zip ${MACUPD_DIR}/MAC006_PRTRPT-${DATE}.pdf ${MACUPD_DIR}/MAC006_ERRRPT-${DATE}.pdf ${MACUPD_DIR}/mac006-${DATE}.pdf
	scp /tmp/macupdate-${DATE}.zip ${ARCH}
	if test $? -eq 0
	then
		rm -f /tmp/macupdate-${DATE}.zip
	else
		echo "-*> Archive of /tmp/macupdate-${DATE}.zip failed."
		exit 1
	fi
}


#
# Main routine
#
# Check command line validity, call usage if incorrect

umask 000

bak ${MAC0000MAS}
${SHELL_DIR}/mac006.sh > ${RPT_DIR}/mac006 2>&1
process_rpt
archive
   

exit 0
