#!/bin/ksh
# warehouse_audit_rerun.sh
#
# Procedure to move around audit files so Dave Tucci can rerun a selected dates audit files
# Runs find command with sort using input arguments and then concatenates appropriopriate file into one file (e.g. LI.rerun).  The output file will need moved manually to another name as needed.
#

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

USAGE: warehouse_audit_rerun.sh date audit
        date - date representation for find command; e.g. 01??08
        audit - 2-character audit prefix; e.g. LI

	e.g. warehouse_audit_rerun.sh 02??08 EX

ENDOFUSAGE
  exit 1
}


if [ $# -lt 2 ]
then
	usage
	exit 1
fi


DATE=$1	# Date of audit files that Dave Tucci needs to rerun
FILE_TYPE=$2	# 2-character prefix for file needed e.g. LI
FILE_DIR="/usr/lnk/sqlimports/audit"

cd ${FILE_DIR}
find . -name "${FILE_TYPE}-${DATE}" -print | sort > /tmp/${FILE_TYPE}_rbexport_files
for file in `cat /tmp/${FILE_TYPE}_rbexport_files`
do
	cat $file >> ${FILE_TYPE}-rerun
done

rm /tmp/${FILE_TYPE}_rbexport_files

exit 0
