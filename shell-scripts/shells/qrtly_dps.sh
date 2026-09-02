#!/bin/ksh
#
# Program Name	: qrtly_dps.sh
# Description   : Quarterly DPS files 
# Author	: Linda S. Jefferis
# Date		: 03/09/1999
# Modifications : 11/15/2000 - Changed pkunzip for new version  (LSJ)
#		: 02/16/2001 - Added UNZIP_PROG variable (LSJ)
#		: 08/10/2001 - Changed drug path from /usr/lnk/drug  (LSJ)
#		: 10/28/2005 - cHANGES for Linux  (LSJ)
#
# Variables Used:
PROD_MACHINE="falcon"
PROD_PATH="/usr/upd/drug"
LOAD_PATH="/usr/upd/drug"
CONV_PROG="/usr/local/bin/char_repl"
ZIP_EXP=expanded.zip
ZIP_NAT=national.zip
TMP_EXP=EXPANDED
TMP_NAT=NATIONAL
DPS_EXP=DPS_EXP
DPS_NAT=DPS_NAT
TMP_DIR=/tmp
UNZIP_PROG="/usr/bin/unzip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: qrtly_dps.sh 

ENDOFUSAGE
  exit 1
}

#

#
# Unzip files
unzip_files()
{
	echo "Unzip files"
	cd ${LOAD_PATH}
	${UNZIP_PROG} -ju -d ${TMP_DIR} ${ZIP_EXP}
	${UNZIP_PROG} -ju -d ${TMP_DIR} ${ZIP_NAT}
}

#
# Convert files
conv_files()
{
	echo "Remove CR and LF characters from files"
	cat ${TMP_DIR}/${TMP_EXP} | ${CONV_PROG} 10 -1 > ${PROD_PATH}/${DPS_EXP}
	cat ${TMP_DIR}/${TMP_NAT} | ${CONV_PROG} 10 -1 > ${PROD_PATH}/${DPS_NAT}
	mv ${PROD_PATH}/${DPS_EXP} ${TMP_DIR}/${TMP_EXP}
	mv ${PROD_PATH}/${DPS_NAT} ${TMP_DIR}/${TMP_NAT}
	cat ${TMP_DIR}/${TMP_EXP} | ${CONV_PROG} 13 -1 > ${PROD_PATH}/${DPS_EXP}
	cat ${TMP_DIR}/${TMP_NAT} | ${CONV_PROG} 13 -1 > ${PROD_PATH}/${DPS_NAT}
}

#
# Cleanup files
clean_up()
{
	rm ${LOAD_PATH}/${ZIP_EXP}
	rm ${LOAD_PATH}/${ZIP_NAT}
	rm ${TMP_DIR}/${TMP_EXP}
	rm ${TMP_DIR}/${TMP_NAT}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

echo "Quarterly DPS files"
date

unzip_files

conv_files

clean_up

date

exit 0
