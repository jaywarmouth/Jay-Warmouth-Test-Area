#!/bin/sh
#

usage()
{
        echo "USAGE:"
        echo "filelist-qacompilecpy.sh filename"
        echo "  filename - file with list of CPY programs to be compiled"
        echo " "
}

if [ $# -eq 0 ]
then
        usage
        exit 99
fi

RPT_FILE=/usr/lnk/rpt/mass-qacpycompile.txt

filelist=$1
date > ${RPT_FILE}
for file in `cat $filelist`
do
	nfile=`echo $file | cut -d. -f1`
	echo $nfile
	rmcompileqa $nfile >> ${RPT_FILE} 2>&1
done
date >> ${RPT_FILE}
echo " "
echo "--> Check ${RPT_FILE} for compile errors"
echo "--> Compiled files are written to /usr/lnk/scm/QArmcob"

exit 0
