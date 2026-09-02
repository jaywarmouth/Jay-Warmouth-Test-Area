#!/bin/ksh
#
# Program Name	: zip_daily_files.sh
# Description	: Zip with password files under /usr/lnk/daily
# Author	: Linda Jefferis
# Date		: 06/23/2013
# modifications : TT #13309-3
#		: 06/22/2015 - TT:13815-1 copy_files logic for BIZTalk
#		: 05/31/2016 - TT3454-39 webclaim logic added
#
# Variables Used:
DAILY=/usr/lnk/daily
ZIP_PROG="/usr/lnk/shell/zippass.sh"
FDATE=`date -d "2 days ago 0800" +%Y%m%d`
ZIPDATE=`date -d "2 days ago 0800" +%Y%m`
PREVDAY=`date -d "yesterday 0800" +%Y%m%d`
BIZTALK_DIR="/usr/lnk/wt/sqlimports/Switch/SwitchDropGZ"

#
# Copy files for BizTalk
copy_files()
{
        for file in `find . -name "switch??-${PREVDAY}*"` 
        do
                file2=`echo $file | cut -d/ -f3`
		gzip -c $file > ${BIZTALK_DIR}/$file2.gz
        done
        for file in `find webclaim -name "-${PREVDAY}*"` 
        do
                file2=`echo $file | cut -d/ -f2`
		gzip -c $file > ${BIZTALK_DIR}/$file2.gz
        done
}

#
# Main routine
#

date

cd ${DAILY}

# Switch files
echo "--> Zipping switch?? files"
find . -name "switch??-${FDATE}*" -print | ${ZIP_PROG} -jm switchfiles-${ZIPDATE}.zip -@

# RTC files
echo "--> Zipping RTC-CLMRT files"
find . -name "CLMRT-${FDATE}*" -print | ${ZIP_PROG} -m clmrtfiles-${ZIPDATE}.zip -@

# Webclaim files
echo "--> Zipping webclaim files"
find webclaim -name "*-${FDATE}" -print | ${ZIP_PROG} -jm webclaimfiles-${ZIPDATE}.zip -@

copy_files

date

exit 0
