#!/bin/sh
#
date > /usr/lnk/scm/POClegacy/leg-allcom.txt
echo "***********************************************************" >> /usr/lnk/scm/POClegacy/leg-allcom.txt
echo "" >> /usr/lnk/scm/POClegacy/leg-allcom.txt
for file in `ls -1 /media/cobol/ShadowDevelopment/Frozen_Code_Production_10-11-2016/CBL`
do
	echo $file
	nfile=`echo $file | cut -d. -f1`
	/usr/lnk/shell/rmcompile_POCleg.sh $nfile >> /usr/lnk/scm/POClegacy/leg-allcom.txt 2>&1
done

echo "*********************************************************" >> /usr/lnk/scm/POClegacy/leg-allcom.txt
echo "compiles completed" >> /usr/lnk/scm/POClegacy/leg-allcom.txt
date >> /usr/lnk/scm/POClegacy/leg-allcom.txt
