#!/bin/sh
#
date > /usr/lnk/scm/POCnew/new-all-compile.txt
echo "**********************************************************" >> /usr/lnk/scm/POCnew/new-all-compile.txt
for file in `ls -1 /media/cobol/ED/Frozen_Code_ED_10-11-2016/CBL`
do
	echo $file
	nfile=`echo $file | cut -d. -f1`
	/usr/lnk/shell/rmcompileD_POCnew.sh $nfile >> /usr/lnk/scm/POCnew/new-all-compile.txt 2>&1
done
echo "************************************************************" >> /usr/lnk/scm/POCnew/new-all-compile.txt
echo "compiles completed" >> /usr/lnk/scm/POCnew/new-all-compile.txt
date >> /usr/lnk/scm/POCnew/new-all-compile.txt
