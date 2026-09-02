#!/bin/sh
#
# Program Name	: prod_zip_daily_files.sh
# Description	: New RedHat: Zip with password files under /usr/lnk/daily amd /usr/local/logs/linedrv
#			Move/Cleanup API Debug log files (/usr/lnk/debug, /usr/lnk/apilog)
# Author	: Linda Jefferis
# Date		: 02/24/2020
#
# Variables Used:
DAILY=/usr/lnk/daily
SW_DIR=/usr/local/logs/linedrv
ZIP_PROG="/usr/lnk/shell/zippass.sh"
FDATE=`date -d "2 days ago 0800" +%Y%m%d`
ZIPDATE=`date -d "2 days ago 0800" +%Y%m`
PREVDAY=`date -d "yesterday 0800" +%Y%m%d`
LOGDATE=`date -d "5 days ago 0800" +%Y%m%d`


#
# Main routine
#

date

cd ${SW_DIR}
# Switch files
echo "--> Zipping switch?? files"
find . -name "switch??-${FDATE}*" -print | ${ZIP_PROG} -jm switchfiles-${ZIPDATE}.zip -@
find . -name "switchfiles-*.zip" -mtime +60 | rm -f {} \;

# Webclaim files
echo "--> Zipping webclaim files"
find webclaim -name "*-${FDATE}" -print | ${ZIP_PROG} -jm webclaimfiles-${ZIPDATE}.zip -@
find . -name "webclaimfiles-*.zip" -mtime +60 | rm -f {} \;


cd ${DAILY}
# RTC files
echo "--> Zipping RTC-CLMRT files"
find . -name "CLMRT-${FDATE}*" -print | ${ZIP_PROG} -m clmrtfiles-${ZIPDATE}.zip -@
find . -name "clmrtfiles-*.zip" -mtime +60 | rm -f {} \;

# Log file removals
echo "--> Removing /usr/local/logs/*.log files for ${LOGDATE}"
cd /usr/local/logs
find . -name "*.${LOGDATE}.log" -exec rm {} \;

# API Debug Log Files
echo "--> Moving/Cleanup of API Debug Log Files"
/usr/lnk/shell/apilog_mv.sh > /tmp/apilog_mv.log.$$ 2>&1


date

exit 0
