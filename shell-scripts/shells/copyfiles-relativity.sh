#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "copy-relativity-files.sh filename"
	echo "  filename - file with list of filenames to be copied"
	echo " "
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

#RPT_FILE=/usr/lnk/rpt/copyfiles.txt
ENVVAR=/usr/lnk/shell/env_var

filelist=$1
DEST_DIR=/data/relativityfiles
date
for file in `cat $filelist`
do
	grep "$file" $ENVVAR
	if test $? -eq 0
	then
		FILEDIR=`grep "$file" $ENVVAR | awk -F= '{ print $2 }'`
		cp ${FILEDIR} ${DEST_DIR}
		if test $? -eq 0
		then
			echo "Copy of $file: completed"
		else
			echo "Copy of $file: failed"
		fi
	else
		echo "The filename, $file, not found in $ENVVAR"
	fi
done
date
echo " "

exit 0
