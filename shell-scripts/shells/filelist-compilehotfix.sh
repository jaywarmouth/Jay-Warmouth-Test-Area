#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "filelist-compilehotfix.sh filename"
	echo "  filename - file with list of programs to be compiled"
	echo "  using CPY/NEWCPY spreadsheet."
	echo " "
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

RPT_FILE=/usr/lnk/rpt/mass-compilehotfix.txt

filelist=$1
date > ${RPT_FILE}
for file in `cat $filelist`
do
	nfile=`echo $file | cut -d. -f1`
	echo $nfile
	/usr/lnk/shell/rmcompileopsgit-hotfix.sh -a $nfile >> ${RPT_FILE} 2>&1
done
date >> ${RPT_FILE}
echo " "
echo "--> Check ${RPT_FILE} for compile errors"
echo "--> Compiled files are written to /usr/lnk/git/rmcob"

grep "Compilation" ${RPT_FILE}

exit 0
