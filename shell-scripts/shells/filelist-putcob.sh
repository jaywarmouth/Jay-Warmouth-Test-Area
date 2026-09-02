#!/bin/sh
#
date > /usr/lnk/rpt/mass-putcob.txt
for file in `cat /tmp/compile-list.txt`
do
	nfile=`echo $file | cut -d. -f1`
	echo $nfile
	putcob $nfile >> /usr/lnk/rpt/mass-putcob.txt 2>&1
done
date >> /usr/lnk/rpt/mass-putcob.txt
