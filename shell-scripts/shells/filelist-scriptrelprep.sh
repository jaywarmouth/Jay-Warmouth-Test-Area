#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "filelist-scriptrelprep.sh filename"
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
LIST_LOC=/usr/lnk/wt/oper-wt/SprintConfigs
filelist=$1
CURR_LOC=/usr/lnk/git/QAscripts
#date > ${RPT_FILE}
for file in `cat $LIST_LOC/$filelist`
do
	echo $file
	zip -j ${CURR_LOC}/deploy-$date.zip ${CURR_LOC}/$file.sh 
	mv ${CURR_LOC}/$file.sh /usr/lnk/git/scripts
done
#date >> ${RPT_FILE}
#echo " "
#echo "--> Check ${RPT_FILE} for errors"

exit 0
