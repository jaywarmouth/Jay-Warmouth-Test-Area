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
BIZTALK_DIR="/usr/lnk/wt/sqlimports/Switch/SwitchDropGZ"
AWS_CP="/usr/local/bin/aws s3 cp"
BUCKET="ga-internal-transfers"
AWS_DIR="SWITCH-CLAIMS/"

#
# Copy files for BizTalk/AWS
copy_files()
{
        for file in `find . -name "switch??-${PREVDAY}*"` 
        do
                file2=`echo $file | cut -d/ -f3`
		gzip -c $file > ${BIZTALK_DIR}/$file2.gz
        done
        for file in `find webclaim -name "webclaim*-${PREVDAY}*"` 
        do
                file2=`echo $file | cut -d/ -f2`
		gzip -c $file > ${BIZTALK_DIR}/$file2.gz
        done
}

#
# Main routine
#

date

cd ${SW_DIR}
# Switch files
echo "--> Copying switch??-${PREVDAY} files to GA"
find . -name "switch??-${PREVDAY}*" -exec ${AWS_CP} {} s3://${BUCKET}/${AWS_DIR} --only-show-errors \;
echo "--> Zipping switch?? files"
find . -name "switch??-${FDATE}*" -print | ${ZIP_PROG} -jm switchfiles-${ZIPDATE}.zip -@

# Webclaim files
echo "--> Copying webclaim ${PREVDAY} files to GA"
find webclaim -name "*-${PREVDAY}*" -exec ${AWS_CP} {} s3://${BUCKET}/${AWS_DIR} --only-show-errors \;
echo "--> Zipping webclaim files"
find webclaim -name "*-${FDATE}" -print | ${ZIP_PROG} -jm webclaimfiles-${ZIPDATE}.zip -@

copy_files


cd ${DAILY}
# RTC files
echo "--> Zipping RTC-CLMRT files"
find . -name "CLMRT-${FDATE}*" -print | ${ZIP_PROG} -m clmrtfiles-${ZIPDATE}.zip -@

# Log file removals
echo "--> Removing /usr/local/logs/*.log files for ${LOGDATE}"
cd /usr/local/logs
find . -name "*.${LOGDATE}.log" -exec rm {} \;

# API Debug Log Files
echo "--> Moving/Cleanup of API Debug Log Files"
/usr/lnk/shell/apilog_mv.sh > /tmp/apilog_mv.log.$$ 2>&1


date

exit 0
