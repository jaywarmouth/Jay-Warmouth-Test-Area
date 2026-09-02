#!/bin/ksh
#
# Program Name	: rm-restack.sh
# Description	: Removing restack event files
# Author	: Linda S. Jefferis
# Date		: 03/27/2014
# Modifications : 07/14/2014 - Add restack.cfg for prod10.
#
# Variables Used:
TMP_DIR="/usr/lnk/shares/ftp-tmp/restack"
RPT_DIR="/usr/lnk/rpt"
RST_DIR="/usr/lnk/tmp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-restack.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

# Check command line validity, call usage if incorrect

rm ${RST_DIR}/rstds-*
rm ${RST_DIR}/restack*
rm ${RST_DIR}/RESTACK*
rm ${RPT_DIR}/rst-*
rm ${TMP_DIR}/*
rm /usr/lnk/restack/restack.cfg

exit 0
