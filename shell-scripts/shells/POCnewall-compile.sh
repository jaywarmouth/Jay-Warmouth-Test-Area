#!/bin/sh
#
date > /usr/lnk/scm/POCnew/newall-compile.txt
echo "**********************************************************" >> /usr/lnk/scm/POCnew/newall-compile.txt
for file in `ls -1 /media/cobol/ED/Frozen_Code_5_26_2015_New_Version_CM6072/CBL using NEWCPY`
do
	echo $file
	nfile=`echo $file | cut -d. -f1`
	/usr/lnk/shell/rmcompilePOCnewone.sh $nfile >> /usr/lnk/scm/POCnew/newall-compile.txt 2>&1
done
echo "************************************************************" >> /usr/lnk/scm/POCnew/newall-compile.txt
echo "compiles completed" >> /usr/lnk/scm/POCnew/newall-compile.txt
date >> /usr/lnk/scm/POCnew/newall-compile.txt
