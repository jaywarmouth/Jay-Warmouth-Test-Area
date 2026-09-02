#!/bin/sh
#

FILELIST=$1
chain=$2
DATE=`date +%Y%m%d`
for paiddate in `cat ${FILELIST}`
do
	/usr/lnk/shell/unzip_835_files.sh -d $paiddate -n $chain
done

exit 0
