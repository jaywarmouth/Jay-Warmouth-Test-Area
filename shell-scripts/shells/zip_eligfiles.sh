#!/bin/sh
#
# Script Name	: zip_eligfile.sh
# Description	: Daily zippass.sh process for archived elig files
# Author	: Linda S. Jefferis
# Date		: 05-29/2013
#		: 06/13/2023 - Added "ACCUM01-ERRSUM-*-${DATE_1}*.txt"
#
# Variables Used:
ELIGOUT=/usr/lnk/elig_out
ZIP_PROG="/usr/lnk/shell/zippass.sh -m"
ZIP_DATE=`date -d "4 days ago" +%Y%m`
DATE_1=`date -d "4 days ago" +%m%d%Y`
DATE_2=`date -d "4 days ago" +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip_eligfiles.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#


cd ${ELIGOUT}
find sys???? -name "ACC01_*_${DATE_1}*" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "ACCUM01-ERRSUM-*-${DATE_1}*.txt" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "${DATE_2}-*-ACC01-*.csv" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "${DATE_2}-*-ACCUM01-ERRSUM-*.txt" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "*-LIMIT-${DATE_2}" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "TCNDC-${DATE_2}*" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "????CA29${DATE_1}.*" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "${DATE_2}-??????-CA29-*.txt" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "${DATE_2}-??????-PRINT-29-*.txt" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "????*-???-Pull-*-${DATE_2}-*.csv" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -name "????*-???-Term-*-${DATE_2}-*.csv" -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@
find sys???? -daystart -mtime +4 ! -type d -print | ${ZIP_PROG} elig_out_${ZIP_DATE}.zip -@

chgrp pdm ${ELIGOUT}/elig_out_${ZIP_DATE}.zip

exit 0
