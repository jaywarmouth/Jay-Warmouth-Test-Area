#!/bin/sh
#
# Program Name	: tr_arx_accum.sh
# Description	: ARX Accumulator Processing 
#		  -f <filename>
#		    Assumes <filename> is located in REMOTE_DIR 
# Author	: Linda S. Jefferis
# Date		: 07/27/2007
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
ACCUM_FILE="null"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
TR_ID="ARX166"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tr_arx_accum.sh -f <filename>

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        ACCUM_FILE=$1
        ;;
  esac
  shift
done

echo "--> Encrypting and transferring file"
ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${REMOTE_DIR}/${ACCUM_FILE}"

echo "--> Cleanup ACCUM_FILE"
ssh -q ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${ACCUM_FILE}"


exit 0
