#!/bin/sh
#
RETVAL=0
DATE=`date +%Y%m%d`
CRDFIXDIR=/usr/upd/claims
FILEDIR=/usr/lnk/wt/benefit-wt/Crdfix/Testinput
OUTDIR=/usr/lnk/wt/benefit-wt/Crdfix/Testresults
SHELL_DIR="/usr/lnk/shell"


TESTFILE=`ls -1 ${FILEDIR}/*.txt`
if test -s ${TESTFILE}
then
	DATETM=`date +%Y%m%d%H%M%S`
	${SHELL_DIR}/crdfix01.sh -f ${TESTFILE} -a D operator > ${OUTDIR}/crdfix01-${DATETM}.doc 2>&1
	RETVAL=$?
	mv ${CRDFIXDIR}/CRDFIX01-* ${OUTDIR}
	mv $TESTFILE ${FILEDIR}/Processed
else
	echo "Issue with CRDFIX file in benefit-wt/Crdfix/Testinput"
	RETVAL=99
fi

exit ${RETVAL}
