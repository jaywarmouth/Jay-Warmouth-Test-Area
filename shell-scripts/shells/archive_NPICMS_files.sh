#!/bin/sh
#
# Program Name	: archive_NPICMS_files.sh
#
# Variables Used:
FILE_DIR=/usr/lnk/wt/oper-wt/NPICMS
ARCH_DIR=/media/backup/archive-1year/NPICMS
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: archive_NPICMS_files.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

mv ${FILE_DIR}/npixls01-week-*.pdf ${ARCH_DIR}
RETVAL_1="$?"
mv ${FILE_DIR}/NPPES_Data_Dissemination*Weekly.zip ${ARCH_DIR}
RETVAL_2="$?"
if [ "$RETVAL_1" -ne "0" -o "$RETVAL_1" -ne "0" ]
then
	RETVAL=99
fi

echo "Process exit code = $RETVAL"
exit $RETVAL

