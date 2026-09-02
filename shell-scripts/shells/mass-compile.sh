#!/bin/sh
#
date > /usr/lnk/rpt/mass-compile.txt
for file in `ls -1 /media/cobol/ShadowProduction/CBL`
do
	echo $file
	nfile=`echo $file | cut -d. -f1`
	echo $nfile
	rmcompile $nfile >> /usr/lnk/rpt/mass-compile.txt 2>&1
done
date >> /usr/lnk/rpt/mass-compile.txt
