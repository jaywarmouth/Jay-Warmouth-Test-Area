#!/bin/ksh
# set_files_for_warehouse_audit_rerun.sh
#
# Procedure to move around audit files so Dave Tucci can rerun a selected dates audit files
#
DATE_1=$1	# Current date(mmddyy)
DATE_2=$2	# Date of audit files that Dave Tucci needs to rerun
FILE_DIR="/usr/lnk/tmp/rb_export"

cd ${FILE_DIR}
find . -name "??.${DATE_1}" -print > /tmp/todays_rbexport_files
for file in `cat /tmp/todays_rbexport_files`
do
	mv $file $file.sav
done

find . -name "??.${DATE_2}" -print > /tmp/needed_rbexport_files
for file in `cat /tmp/needed_rbexport_files`
do
	PREFIX=`echo $file | cut -c3-4`
	cp ${PREFIX}.${DATE_2} ${PREFIX}.${DATE_1}
done

rm /tmp/todays_rbexport_files
rm /tmp/needed_rbexport_files

exit 0
