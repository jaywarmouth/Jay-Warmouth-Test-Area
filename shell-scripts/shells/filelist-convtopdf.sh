#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "filelist-convtopdf.sh filename from_location to_location"
	echo "  filename - list of files to be converted to PDF"
	echo "  from_location - full directory name where copying FROM"
	echo "  to_location - full directory name where copying TO"
	echo " "
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

filelist=$1
fr_loc=$2
to_loc=$3
for file in `cat $filelist`
do
	nfile=`echo $file | cut -d. -f1`
	echo $file
	enscript -rB -a2- -f Courier9 -o - $fr_loc/$nfile.txt | ps2pdf - $to_loc/$nfile.pdf
done

exit 0
