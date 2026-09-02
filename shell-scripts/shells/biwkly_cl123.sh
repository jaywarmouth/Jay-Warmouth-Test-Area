#!/bin/sh
#
# Program Name	: biwkly_cl123.sh
# Description	: Process sys0058 claim123 reports
#		  Command Line:
#		  -d <ccyymmdd> - p/e date
# Author	: Linda S. Jefferis
# Date		: 9/4/2013
# Modifications :  
#
# Variables Used:
OUTDIR=/usr/lnk/po/sys0058
ZIP_PROG=/usr/bin/zip


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: biwkly_cl123.sh -d <ccyymmdd>
	where <ccyymmdd> is p/e date

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
        usage
        exit 1
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	;;
  esac 
  shift
done


cd /usr/lnk/po/sys0058
a2ps -1Bl132 -o - ???CL123Z-P.L9 | ps2pdf - $OUTDIR/0058-summary-differential.pdf
find spo* -name "???CL123A-P.L9" -print > tmplist
for file in `cat tmplist`
do
	SPO=`echo $file | cut -c 4-7`
	a2ps -1Bl132 -o - $file | ps2pdf - $OUTDIR/$SPO-summary-differential.pdf
done
find spo* -name "???CL123B-P.L9" -print > tmplist
for file in `cat tmplist`
do
        SPO=`echo $file | cut -c 4-7`
        a2ps -1Bl132 -o - $file | ps2pdf - $OUTDIR/$SPO-detail-differential.pdf
done

${ZIP_PROG} -mj $OUTDIR/URX-Differentials-${DATE}.zip $OUTDIR/*-differential.pdf


exit 0
