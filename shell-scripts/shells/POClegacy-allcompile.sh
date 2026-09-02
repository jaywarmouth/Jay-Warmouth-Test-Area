#!/bin/sh
#
date > /usr/lnk/scm/POClegacy/legacy-allcompile.txt
echo "***********************************************************" >> /usr/lnk/scm/POClegacy/legacy-allcompile.txt
echo "" >> /usr/lnk/scm/POClegacy/legacy-allcompile.txt
for file in `ls -1 /media/cobol/ShadowDevelopment/Frozen_Code_5_26_2015_Production_Version_CM6072/CBL`
do
	echo $file
	nfile=`echo $file | cut -d. -f1`
	/usr/lnk/shell/rmcompile_POClegacy.sh $nfile >> /usr/lnk/scm/POClegacy/legacy-allcompile.txt 2>&1
done

echo "*********************************************************" >> /usr/lnk/scm/POClegacy/legacy-allcompile.txt
echo "compiles completed" >> /usr/lnk/scm/POClegacy/legacy-allcompile.txt
date >> /usr/lnk/scm/POClegacy/legacy-allcompile.txt
