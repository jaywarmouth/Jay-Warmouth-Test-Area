#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "filelist-prodrelprep.sh filename"
	echo "  filename - file with list of programs"
	echo " "
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

#RPT_FILE=/usr/lnk/rpt/mass-prodrelprep.txt

date=`date +%Y%m%d`
filelist=$1
#date > ${RPT_FILE}
for file in `cat $filelist`
do
	echo $file
	find /usr/lnk/git/QArmcob/Archive -name "deploy-*.zip" -mtime +21 -exec rm -f {} \;
	zip -j /usr/lnk/git/QArmcob/Archive/deploy-$date.zip /usr/lnk/git/QArmcob/$file.cob /usr/lnk/git/QArmcob/$file.lst
	mv /usr/lnk/git/QArmcob/$file.cob /usr/lnk/git/rmcob
	mv /usr/lnk/git/QArmcob/$file.lst /usr/lnk/git/rmcob	
done
#date >> ${RPT_FILE}
#echo " "
#echo "--> Check ${RPT_FILE} for errors"

exit 0
