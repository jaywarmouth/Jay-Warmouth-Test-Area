#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "filelist-compileproj.sh filename cobdir"
	echo "  filename - file with list of programs to be compiled"
	echo "  cobdir - sub-directory under /usr/lnk/git/Projrmcob to write object and lst files"
	echo " "
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

RPT_FILE=/usr/lnk/rpt/mass-compileproj.txt

filelist=$1
cobdir=$2
date > ${RPT_FILE}
for file in `cat $filelist`
do
	nfile=`echo $file | cut -d. -f1`
	echo $nfile
	/usr/lnk/shell/rmcompileopsgit-proj.sh -a $nfile $cobdir >> ${RPT_FILE} 2>&1
done
date >> ${RPT_FILE}
echo " "
echo "--> Check ${RPT_FILE} for compile errors"
echo "--> Compiled files are written to /usr/lnk/git/Projrmcob/$cobdir"

grep "Compilation" ${RPT_FILE}

exit 0
