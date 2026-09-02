#!/bin/sh
#
date > /usr/lnk/scm/POCnew/new-allcompile.txt
echo "**********************************************************" >> /usr/lnk/scm/POCnew/new-allcompile.txt
for file in `ls -1 /media/cobol/ED/Frozen_Code_5_26_2015_New_Version_CM6072/CBL`
do
	echo $file
	nfile=`echo $file | cut -d. -f1`
	/usr/lnk/shell/rmcompile_POCnew.sh $nfile >> /usr/lnk/scm/POCnew/new-allcompile.txt 2>&1
done
echo "************************************************************" >> /usr/lnk/scm/POCnew/new-allcompile.txt
echo "compiles completed" >> /usr/lnk/scm/POCnew/new-allcompile.txt
date >> /usr/lnk/scm/POCnew/new-allcompile.txt
