#!/bin/sh
#
RETVAL=0
WH_DIR=/usr/lnk/wt/sqlimports/ClaimFixReport
DATE=`date +%Y%m%d`
FIXFILE=/usr/lnk/sqlimports/claims/CLM-FIX-REPORT-${DATE}

if test -s ${FIXFILE}
then
	mv ${FIXFILE} ${WH_DIR}
	if test $? -ne 0
	then
		RETVAL=99
	fi
else
	RETVAL=1
fi

exit ${RETVAL}
