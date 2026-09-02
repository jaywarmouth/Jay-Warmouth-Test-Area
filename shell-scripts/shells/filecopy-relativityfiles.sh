#!/bin/sh
#

usage()
{
	echo ""
	echo "USAGE:"
	echo "filecopy-relativityfiles.sh <filelist> <dir>"
	echo " "
	echo "filelist - name of file in /usr/local/etc/relativity/ directory with filelist"
	echo "dir - /data/relativityfiles/ sub-directory where files will be copied to"
	echo ""
	exit 99
}

if [ $# -lt 2 ]
then
	usage
fi

filename=$1
dir=$2
filelist=/usr/local/etc/relativity/$filename
destdir=/data/relativityfiles/$dir

if [ ! -d "$destdir" ]
then
        mkdir -m 755 $destdir
	if test $? -ne 0
	then
		usage
	fi
fi

for file in `cat $filelist`
do
	date
	scp $file $destdir
	if test $? -eq 0
	then
		echo "$file - COPY COMPLETE"
	else
		echo "$file - FAILED"
	fi
done
date
chmod 664 $destdir/*

exit 
