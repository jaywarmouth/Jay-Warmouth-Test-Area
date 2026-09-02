#!/bin/sh

PATH=/opt/rmcobol:$PATH
FILE_DIR=/usr/lnk/crd_02
DATE=`date +%Y%m%d`
date > /tmp/prod11-cardh-refresh
echo "" >> /tmp/prod11-cardh-refresh
scp prod10:${FILE_DIR}/CARDH00MAS ${FILE_DIR}/CARDH00MAS.tmp
if test $? -eq 0
then
	/usr/lnk/shell/cardh-compu13.sh -i /usr/lnk/log/PARMFILE-COMPU13-CARDH.txt -o /tmp/cardh-compu13-${DATE}.txt >> /tmp/prod11-cardh-refresh 2>&1
	if test $? -eq 0
	then
		cp ${FILE_DIR}/CARDH00MAS.tmp ${FILE_DIR}/CARDH00MAS
		echo "CARDH00MAS copy Complete" >> /tmp/prod11-cardh-refresh
	else
		echo "" >> /tmp/log-cardhtmp
		echo "Running recover1 on ${FILE_DIR}/CARDH00MAS.tmp" >> /tmp/prod11-cardh-refresh
		/usr/rmcobol/recover1 ${FILE_DIR}/CARDH00MAS.tmp /tmp/drop-cardhtmp -L /tmp/log-cardhtmp -Q -Y		
		if test $? -eq 0
		then
			echo "" >> /tmp/prod11-cardh-refresh
			cp ${FILE_DIR}/CARDH00MAS.tmp ${FILE_DIR}/CARDH00MAS
			echo "CARDH00MAS copy and recovery Complete" >> /tmp/prod11-cardh-refresh
		else
			echo "" >> /tmp/prod11-cardh-refresh
			echo "Recover file Failure" >> /tmp/prod11-cardh-refresh
		fi
		cat /tmp/log-cardhtmp >> /tmp/prod11-cardh-refresh
	fi
else
	echo "Failure of CARDH00MAS copy" >> /tmp/prod11-cardh-refresh
fi
rm -f ${FILE_DIR}/CARDH00MAS.tmp
echo "" >> /tmp/prod11-cardh-refresh
date >> /tmp/prod11-cardh-refresh

/usr/bin/mutt -s "PROD11 - CARDH File Refresh and Recovery" operations@pdmi.com < /tmp/prod11-cardh-refresh

