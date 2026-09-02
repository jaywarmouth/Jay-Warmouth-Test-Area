#!/bin/ksh
# reset_files_after_warehouse_audit_rerun.sh
#
# Puts back original files after Dave Tucci did the needed audit rerun
#
DATE_1=$1	# Current date(mmddyy)
FILE_DIR="/usr/lnk/tmp/rb_export"

cd ${FILE_DIR}
find . -name "??.${DATE_1}.sav" -print > /tmp/todays_saved_files
for file in `cat /tmp/todays_saved_files`
do
	PREFIX=`echo $file | cut -c3-4`
	mv $file ${PREFIX}.${DATE_1}
done

rm /tmp/todays_saved_files

exit 0
