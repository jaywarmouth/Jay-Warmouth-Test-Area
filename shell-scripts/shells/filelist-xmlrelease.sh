#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "filelist-xmlrelease.sh filename"
	echo "  filename - list of xml files to be copied from COBOL_GIT"
	echo " "
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

RPT_FILE=/usr/lnk/rpt/mass-xmlrelease.txt

filelist=$1
date > ${RPT_FILE}
for file in `cat $filelist`
do
	echo $file
	cp /usr/lnk/COBOL_GIT/STYLE_SHEETS/$file /usr/lnk/git/stylesheets
done
date >> ${RPT_FILE}
echo " "
echo "--> Check ${RPT_FILE} for copy errors"
echo "--> files are written to /usr/lnk/git/stylesheets"

exit 0
